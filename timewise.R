# This files generates 
# Here we re-run the classification,  
options(error=traceback)
# enable commandline arguments from script launched using Rscript
args<-commandArgs(TRUE)

library(caret)
library(ROCR)
library(pROC)
library(zoo)

set.seed(875)

if(!exists("save_results", mode="function")) 
  source(paste(getwd(), "lib/save_results.R", sep="/"))
if(!exists("scalar_metrics", mode="function")) 
  source(paste(getwd(), "lib/scalar_metrics.R", sep="/"))
if(!exists("setup_dataframe", mode="function")) 
  source(paste(getwd(), "lib/setup_dataframe.R", sep="/"))
if(!exists("enable_parallel", mode="function")) 
  source(paste(getwd(), "lib/enable_parallel.R", sep="/"))
if(!exists("plot_curve", mode="function")) 
  source(paste(getwd(), "lib/plot_curve.R", sep="/"))

next.month <- function(d, step=1) as.yearmon( as.Date(as.yearmon(d) + step/12) + as.numeric(as.Date(d) - as.Date(as.yearmon(d))) )

prev.month <- function(d, step=1) as.yearmon( as.Date(as.yearmon(d) - step/12) + as.numeric(as.Date(d) - as.Date(as.yearmon(d))) )

get_grid <- function(classifier) {
  grid <- NULL
  if(classifier == "xgbTree") {
    grid <- data.frame(nrounds = 200, 
                       max_depth = 4, 
                       eta = 0.1, 
                       gamma = 0, 
                       colsample_bytree = 1, 
                       min_child_weight = 1,
                       subsample = 1)
  }
  else if(classifier == "gbm") {
    grid <- data.frame(n.trees = 250, 
                       interaction.depth = 3, 
                       shrinkage = 0.1,
                       n.minobsinnode = 10)
  }
  else if(classifier == "pcaNNet") {
    grid <- data.frame(size = 7, decay = 0.1)
  }
  else if(classifier == "earth") {
    grid <- data.frame(nprune = 15, degree = 1)
  }
  return(grid)
}

# name of outcome var to be predicted
outcomeName <- "solution"
time_format="%Y-%m-%d %H:%M:%S"
# list of predictor vars by name
#excluded_predictors <- c("resolved", "answer_uid", "question_uid", "answers_count")
excluded_predictors <- c("resolved", "answer_uid", "question_uid", "views", "views_rank",
                         "has_code_snippet", "has_tags", "loglikelihood_descending_rank", "F.K_descending_rank")

# load dataset
csv_file <- ifelse(is.na(args[1]), "input/so_341k.csv", args[1])
temp <- read.csv(csv_file, header = TRUE, sep=",")
temp$year_mon <- as.yearmon((temp$date_time))
#min_year_mon <- min(temp$year_mon)
min_year_mon <- as.yearmon("2009-01") # cuts out initial training set (year 2008)
max_year_mon <- max(temp$year_mon)
yrs <- round(max_year_mon - min_year_mon)


x <- setup_dataframe(dataframe = temp, outcomeName=outcomeName, excluded_predictors=excluded_predictors,
                        time_format=time_format, normalize=TRUE, na_omit=TRUE)
SO <- x[[1]]
SO <- SO[order(SO$year_mon),]  # order by time
observations <- nrow(SO)
soPredictorsNames <- x[[2]]
soPredictorsNames <- soPredictorsNames[1:length(soPredictorsNames)-1]  # remove year_mon by index (it's the last elem added)
soPredictorsNames <- soPredictorsNames[1:1-3] # remove date_time by index (it's the 2nd elem)

# remove large unused objects from memory
rm(x)
# garbage collection
gc()

obs_distrib <-c()
months <-c ()
i_month <- min_year_mon
while (i_month < max_year_mon) {
  months <- c(months, as.character.Date(i_month, "%Y-%m"))
  obs <- SO[SO$year_mon <= prev.month(i_month), ]
  obs_distrib <- c(obs_distrib, nrow(obs))
  i_month <- next.month(i_month, step = 2)
}

models_file <- ifelse(is.na(args[2]), "models/top-models1.txt", args[2])
classifiers <- readLines(models_file)

fitControl <- trainControl(
  method = "none",
  # binary problem
  summaryFunction=twoClassSummary,
  classProbs = TRUE,
  # enable parallel computing if avail
  allowParallel = TRUE,
  returnData = FALSE,
  verboseIter = FALSE, 
  preProcOptions = c("center", "scale")
)
line_types <- 1:length(classifiers)
g_col <- rainbow(length(classifiers))

AUC_list <- list('classifiers'=c(), aucs=list())
# load all the classifiers to test
for(i in 1:length(classifiers)){
  nline <- strsplit(classifiers[i], ":")[[1]]
  classifier <- nline[1]
  classifiers[i] <- classifier
  AUC_list$classifiers <- c(AUC_list$classifiers, classifier)
  print(paste("Testing performance of classifier", classifier))
  grid <- get_grid(classifier)
  
  aucs <- c()
  current_y_m <- as.yearmon(as.POSIXct("2009-01-01"))
  j <- 0
  while(current_y_m < max_year_mon){
    j <- j+1
    print( paste("Testing on months", paste(as.character(current_y_m), as.character(next.month(current_y_m, step = 2)), sep=" - ")) )
    prev_y_m = prev.month(current_y_m)
    current_trainingset <- SO[SO$year_mon <= prev_y_m, !(names(SO) %in% c("date_time", "year_mon"))]
    #build model
    model <- caret::train(solution ~ ., 
                          data = current_trainingset,
                          method = classifier,
                          trControl = fitControl,  
                          tuneGrid = grid)
    
    testing <- SO[(SO$year_mon >= current_y_m) & (SO$year_mon <= next.month(current_y_m, step = 2)), !(names(SO) %in% c("date_time", "year_mon"))]
    
    #prediction 
    pred_prob <- predict(model, testing[, soPredictorsNames], type = 'prob')
    model.prediction_prob <- ROCR::prediction(pred_prob[,2], testing[,outcomeName])
    predictions <- c(model.prediction_prob)
    rocobj <- roc(as.numeric(testing[,outcomeName])-1, pred_prob[,2])
    aucs[j] <- round(rocobj$auc , digits = 2)
    
    pred <- predict(model, testing[, soPredictorsNames])
    cm <- caret::confusionMatrix(table(data=pred, reference=testing[,outcomeName]), positive="True")
    # save cm to text file
    save_results(outfile = paste(as.character(current_y_m), "txt", sep="."), outdir = paste("output/timewise/cm", classifier, sep="/"), 
                 classifiers = classifiers, results = cm, expanded = TRUE)
    scalar_metrics(predictions=pred, truth=testing[,outcomeName], 
                   outdir=paste("output/timewise/scalar", classifier, sep="/"), outfile=paste(as.character(current_y_m), "txt", sep = "."))
    # plot ROC
    op <- par(no.readonly=TRUE) #this is done to save the default settings
    plot_dir <- paste("output/timewise/plots",  classifier, sep = "/")
    if(!dir.exists(plot_dir))
      dir.create(plot_dir, showWarnings = FALSE, recursive = TRUE, mode = "0777")

    tiff(filename=paste(plot_dir, paste(as.character(current_y_m), "roc_plot.tiff", sep="_"), sep = "/"),
         type = "quartz", compression = "none", width = 600, height = 600)
    tryCatch({
      t <- rocobj
      t <- smooth(rocobj)
    }, error = function(e) {
      # ignore
    })
    rocobj <-t
    plot(main=paste(as.character(current_y_m), as.character(next.month(current_y_m, step = 2)), sep = " - "), rocobj, col = g_col[i], 
         lty = line_types[i], lwd = 1.8)
    legend(
      "bottomright",
      xpd=TRUE,
      #inset = .1,
      inset = c(0,0),
      title = "Model",
      paste(classifiers[i], " (AUC=", aucs[j], ")", sep=""),
      horiz = TRUE,
      lty = c(1:length(classifiers)),
      lwd = 2.5,
      col = g_col,
      cex=0.9, pt.cex = 1, 
      bty = 'n',
      box.col = "grey"
    )
    # plot_curve(predictions=predictions, classifiers=classifiers, 
    #            colors=g_col, line_type=line_types, 
    #            x_label="fpr", y_label="tpr", leg_pos="bottomright", plot_abline=TRUE, 
    #            leg_title="", main_title=paste(as.character(current_y_m), as.character(next.month(current_y_m, step = 2)), sep = " - "), leg_horiz=FALSE, aucs=aucs)
    dev.off()
    par(op) #re-set the plot to the default settings

    current_y_m = next.month(current_y_m, step = 2)
  }
  AUC_list$aucs <- append(AUC_list$aucs, list(aucs))
  
  tiff(filename=paste(plot_dir, paste(classifiers[i], "auc_plot.tiff", sep="_"), sep = "/"),
       type = "quartz", compression = "none", width = 800, height = 480)
  lab <- format(months,format="%y-%b")
  op <- par(mar=c(6,4,1,1))
  df <- as.data.frame(list('month'=months, 'answers'=obs_distrib))
  plot(x=df$month, y=RSNNS::normalizeData(df$answers, type="0_1"), type="n", xlab="", yaxt="n", xaxt="n", border="darkgrey")
  xspline(x=df$month, y=RSNNS::normalizeData(df$answers, type="0_1"), shape=1, border = "grey", lty="dashed", lwd=2)
  plot(x=df$month, y=AUC_list$aucs[[i]], add=TRUE, type="n", xlab="", yaxt="n", xaxt="n")
  xspline(x=df$month, y=AUC_list$aucs[[i]], shape=1, lwd=2)
  axis(1, at=df$month, labels=FALSE)
  axis(2, at=c(0,1), labels=TRUE)
  text(x=df$month, y=par()$usr[3]-0.04*(par()$usr[4]-par()$usr[3]),
       labels=lab, srt=45, adj=1, xpd=TRUE, cex=0.7)
  xspline(x=df$month, y=rep(mean(AUC_list$aucs[[i]]), length(df$month)), border="grey")#, add=TRUE, , xlab="", yaxt="n", xaxt="n", lty=4)
  legend(
    "bottomright",
    xpd=TRUE,
    #inset = .1,
    inset = c(0,0),
    legend=c(paste("Mean AUC", round(mean(AUC_list$aucs[[i]]), 2), sep = " "), "AUC", "Training set size"),
    title = classifiers[i],
    horiz = FALSE,
    lty = c(1,1,2),
    lwd = 2.5,
    col = c("gray", "black", "darkgray"),
    cex=0.9, pt.cex = 1, 
    bty = 'n',
    box.col = "grey"
  )
  par(op)
  dev.off()
} 





