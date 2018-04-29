# This files is meant to assess the performance of the top-performing classifiers on
# the SO dataset without using upvotes and upvotes_ranked as predictors

# enable commandline arguments from script launched using Rscript
args<-commandArgs(TRUE)

library(caret)
library(ROCR)
library(pROC)

set.seed(875)

if(!exists("save_results", mode="function")) 
  source(paste(getwd(), "lib/save_results.R", sep="/"))
if(!exists("scalar_metrics", mode="function")) 
  source(paste(getwd(), "lib/scalar_metrics.R", sep="/"))
if(!exists("setup_dataframe", mode="function")) 
  source(paste(getwd(), "lib/setup_dataframe.R", sep="/"))
# enables multicore parallel processing 
if(!exists("enable_parallel", mode="function")) 
  source(paste(getwd(), "lib/enable_parallel.R", sep="/"))
if(!exists("get_graphic_type", mode="function")) 
  source(paste(getwd(), "lib/graphic_type.R", sep="/"))
if(!exists("get_grid", mode="function")) 
  source(paste(getwd(), "lib/tuned_grid.R", sep="/"))

# name of outcome var to be predicted
outcomeName <- "solution"
# load dataset
excluded_predictors <- c("answer_uid", "question_uid", "views", "views_rank",
                         "has_code_snippet", "has_tags", "loglikelihood_descending_rank", "F.K_descending_rank",
                         "upvotes", "upvotes_rank")

# load dataset
csv_file <- ifelse(is.na(args[1]), "input/wo_341k.csv", args[1])
temp <- read.csv(csv_file, header = TRUE, sep=",")
temp <- setup_dataframe(dataframe = temp, outcomeName = outcomeName, excluded_predictors = excluded_predictors,
                        time_format="%Y-%m-%d %H:%M:%S", normalize = FALSE)
so <- temp[[1]]
predictorsNames <- temp[[2]]
splitIndex <- createDataPartition(so[,outcomeName], p = .70, list = FALSE)
soTraining <- so[splitIndex, ]
soTesting <- so[-splitIndex, ]

# remove large unused objects from memory
rm(so)
rm(temp)
# garbage collection
gc()

classifiers <- readLines("models/top-models.txt")
predictions <- c()
aucs <- c()
rocobjs_without <- c()
for(i in 1:length(classifiers)){
  nline <- strsplit(classifiers[i], ":")[[1]]
  classifier <- nline[1]
  classifiers[i] <- classifier
  grid <- get_grid(classifier)
  
  print(paste("Testing performance of classifier", classifier))
  model <- caret::train(solution ~ ., 
                        data = soTraining,
                        method = classifier,
                        trControl = trainControl(method="none", 
                                                 classProbs = TRUE
                                                 ),  
                        tuneGrid = grid,  
                        preProcess = c("center", "scale")
                        )
  
  pred_prob <- predict(model, soTesting[,predictorsNames], type = 'prob')
  model.prediction_prob <- ROCR::prediction(pred_prob[,2], soTesting[,outcomeName])
  predictions <- c(predictions, model.prediction_prob)
  rocobj <- pROC::roc(soTesting[,outcomeName], pred_prob[,2], levels=c("False", "True"), direction="<")
  rocobjs_without[i] <- list(rocobj)
  print(classifier)
  auc <- round(rocobj$auc, digits = 2)
  print(auc)
  aucs <- c(aucs, auc) 
}

# and plot ROC curve

line_types <- 1:length(classifiers)
g_col <- rainbow(length(classifiers))

if(!exists("plot_curve", mode="function")) 
  source(paste(getwd(), "lib/plot_curve.R", sep="/"))

op <- par(no.readonly=TRUE) #this is done to save the default settings
plot_dir <- paste("output/plots", "so", sep = "/")
if(!dir.exists(plot_dir))
  dir.create(plot_dir, showWarnings = FALSE, recursive = TRUE, mode = "0777")

tiff(filename=paste(plot_dir, paste("so", "roc_plot_no_upvotes.tiff", sep="_"), sep = "/"), 
     type = get_graphic_type(), compression = "none", width = 2000, height = 2000, pointsize = 20, res=200)
plot_curve(predictions= predictions,
           #predictions= rocobjs,
           classifiers=classifiers, 
           colors=g_col, line_type=line_types, 
           x_label="fpr", y_label="tpr", leg_pos="bottomright", plot_abline=TRUE, 
           leg_title="", main_title="", leg_horiz=FALSE, aucs=aucs)
dev.off()
par(op) #re-set the plot to the default settings


## Now repeate again, but with the score features enabled
## then perform a ROC test between each pair of model
excluded_predictors <- c("answer_uid", "question_uid", "views", "views_rank",
                         "has_code_snippet", "has_tags", "loglikelihood_descending_rank", "F.K_descending_rank"
                         )
temp <- read.csv(csv_file, header = TRUE, sep=",")
temp <- setup_dataframe(dataframe = temp, outcomeName = outcomeName, excluded_predictors = excluded_predictors,
                        time_format="%Y-%m-%d %H:%M:%S", normalize = FALSE)
so <- temp[[1]]
predictorsNames <- temp[[2]]
splitIndex <- createDataPartition(so[,outcomeName], p = .70, list = FALSE)
soTraining <- so[splitIndex, ]
soTesting <- so[-splitIndex, ]

rocobjs_with <- c()
for(i in 1:length(classifiers)){
  nline <- strsplit(classifiers[i], ":")[[1]]
  classifier <- nline[1]
  classifiers[i] <- classifier
  grid <- get_grid(classifier)
  
  print(paste("Testing performance of classifier", classifier))
  model <- caret::train(solution ~ ., 
                        data = soTraining,
                        method = classifier,
                        trControl = trainControl(method="none", 
                                                 classProbs = TRUE
                        ),  
                        tuneGrid = grid,  
                        preProcess = c("center", "scale")
  )
  
  pred_prob <- predict(model, soTesting[,predictorsNames], type = 'prob')
  rocobj <- pROC::roc(soTesting[,outcomeName], pred_prob[,2], levels=c("False", "True"), direction="<")
  rocobjs_with[i] <- list(rocobj)
}

# test performance setting all upvotes to ZERO
soTesting$upvotes=0
soTesting$upvotes_rank=0
soTraining$upvotes=0
soTraining$upvotes_rank=0

rocobjs_zeroed <- c()
for(i in 1:length(classifiers)){
  nline <- strsplit(classifiers[i], ":")[[1]]
  classifier <- nline[1]
  classifiers[i] <- classifier
  grid <- get_grid(classifier)
  
  print(paste("Testing performance of classifier", classifier))
  model <- caret::train(solution ~ ., 
                        data = soTraining,
                        method = classifier,
                        trControl = trainControl(method="none", 
                                                 classProbs = TRUE
                        ),  
                        tuneGrid = grid,  
                        preProcess = c("center", "scale")
  )
  
  pred_prob <- predict(model, soTesting[,predictorsNames], type = 'prob')
  rocobj <- pROC::roc(soTesting[,outcomeName], pred_prob[,2], levels=c("False", "True"), direction="<")
  rocobjs_zeroed[i] <- list(rocobj)
}

for(i in 1:length(classifiers)){
  print(paste(classifiers[i], round(rocobjs_zeroed[[i]]$auc, 2)), sep= " ")
}


# reload dataset
csv_file <- ifelse(is.na(args[1]), "input/so_341k.csv", args[1])
temp <- read.csv(csv_file, header = TRUE, sep=",")
temp <- setup_dataframe(dataframe = temp, outcomeName = outcomeName, excluded_predictors = excluded_predictors,
                        time_format="%Y-%m-%d %H:%M:%S", normalize = FALSE)
so <- temp[[1]]
predictorsNames <- temp[[2]]
splitIndex <- createDataPartition(so[,outcomeName], p = .70, list = FALSE)
soTraining <- so[splitIndex, ]
soTesting <- so[-splitIndex, ]
# test performance setting all upvotes to ZERO
soTesting$upvotes=median(soTesting$upvotes)
soTesting$upvotes_rank=median(soTesting$upvotes_rank)
soTraining$upvotes=median(soTraining$upvotes)
soTraining$upvotes_rank=median(soTraining$upvotes_rank)

rocobjs_median <- c()
for(i in 1:length(classifiers)){
  nline <- strsplit(classifiers[i], ":")[[1]]
  classifier <- nline[1]
  classifiers[i] <- classifier
  grid <- get_grid(classifier)
  
  print(paste("Testing performance of classifier", classifier))
  model <- caret::train(solution ~ ., 
                        data = soTraining,
                        method = classifier,
                        trControl = trainControl(method="none", 
                                                 classProbs = TRUE
                        ),  
                        tuneGrid = grid,  
                        preProcess = c("center", "scale")
  )
  
  pred_prob <- predict(model, soTesting[,predictorsNames], type = 'prob')
  rocobj <- pROC::roc(soTesting[,outcomeName], pred_prob[,2], levels=c("False", "True"), direction="<")
  rocobjs_median[i] <- list(rocobj)
}

for(i in 1:length(classifiers)){
  print(paste(classifiers[i], round(rocobjs_median[[i]]$auc, 2)), sep= " ")
}

