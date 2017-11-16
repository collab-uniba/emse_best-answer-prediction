# This files generates the ROC plots for the top-ranked (Scott-Knott test) models.
# Here we re-run the classification, with the same seed and param config under which the generated models
# achieved the best performance. Then, we plot the predictions
set.seed(345)
# enable commandline arguments from script launched using Rscript
args<-commandArgs(TRUE)

library(caret)
library(DMwR)
library(ROCR)
library(pROC)

if(!exists("save_results", mode="function")) 
  source(paste(getwd(), "lib/save_results.R", sep="/"))
if(!exists("scalar_metrics", mode="function")) 
  source(paste(getwd(), "lib/scalar_metrics.R", sep="/"))
if(!exists("setup_dataframe", mode="function")) 
  source(paste(getwd(), "lib/setup_dataframe.R", sep="/"))
# enables multicore parallel processing 
if(!exists("enable_parallel", mode="function")) 
  source(paste(getwd(), "lib/enable_parallel.R", sep="/"))

# name of outcome var to be predicted
outcomeName <- "solution"
# removes outcome variables solution/resolved plus
# predictors available in the dataset files but not used in the paper
excluded_predictors <- c("resolved", "answer_uid", "question_uid", "views", "views_rank",
                         "has_code_snippet", "has_tags", "loglikelihood_descending_rank", "F.K_descending_rank")

csv_file <- ifelse(is.na(args[1]), "input/so_341k.csv", args[1])
temp <- read.csv(csv_file, header = TRUE, sep=",")
temp <- setup_dataframe(dataframe = temp, outcomeName = outcomeName, excluded_predictors = excluded_predictors,
                        time_format="%Y-%m-%d %H:%M:%S", normalize = TRUE, na_omit = TRUE)
SO <- temp[[1]]
predictorsNames <- temp[[2]]

choice <- ifelse(is.na(args[2]), "so", args[2])
#choice <- "test"

if(choice == "so") {
  seeds <- readLines("seeds.txt")
  set.seed(seeds[length(seeds)])
  splitIndex <- createDataPartition(SO[,outcomeName], p = .70, list = FALSE)
  testing <- SO[-splitIndex, ]
  #summary(SO$solution)
} else { ## handles different time formats
  if(choice == "docusign") { 
    csv_file <- "input/docusing.csv"
    sep <- ";"
    time_format <- "%d/%m/%Y %H:%M:%S"
  } else if(choice == "dwolla") { 
    csv_file <- "input/dwolla.csv"
    sep <- ";"
    time_format <- "%d/%m/%Y %H:%M"
  } else if(choice == "yahoo") { 
    csv_file <- "input/yahoo.csv"
    sep <- ";"
    time_format <- "%Y-%m-%d %H:%M:%S"
  } else if(choice == "scn") {
    csv_file <- "input/scn.csv"
    sep <- ","
    time_format <- "%Y-%m-%d %H:%M:%S"
  } else { ## assume a test is run without param from command line
    csv_file <- "input/example.csv"
    sep <- ","
    time_format <- "%Y-%m-%d %H:%M:%S"
  }

  # load testing file and predictors
  temp <- read.csv(csv_file, header = TRUE, sep=sep)
  temp <- setup_dataframe(dataframe = temp, outcomeName = outcomeName, excluded_predictors = excluded_predictors,
                          time_format=time_format, normalize = FALSE)
  testing <- temp[[1]]
}

# remove large unused objects from memory
rm(csv_file)
rm(temp)
# garbage collection
gc()

models_file <- ifelse(is.na(args[3]), "models/top-cluster.txt", args[3])
classifiers <- readLines(models_file)
predictions <- c()
cmatrices <- c()
aucs <- c()
prec_rec <- c()

# for model: XYZ
set.seed(875)
# model with optimal parameters.
# modelX <- classifier(solution ~ ., data = training, parameters...)
# modelX.pred <- predict(modelX, testing)

# load all the classifiers to test
for(i in 1:length(classifiers)){
  nline <- strsplit(classifiers[i], ":")[[1]]
  classifier <- nline[1]
  classifiers[i] <- classifier
  
  print(paste("Testing performance of classifier", classifier)) 
  model <- caret::train(solution ~ ., 
                        data = SO,
                        method = classifier,
                        trControl = trainControl(method="none", classProbs = TRUE),  
                        tuneGrid = grid,  preProcess = c("center", "scale"))
  
  pred_prob <- predict(model, testing[,predictorsNames], type = 'prob')
  model.prediction_prob <- ROCR::prediction(pred_prob[,2], testing[,outcomeName])
  predictions <- c(predictions, model.prediction_prob)
  aucs <- c(aucs, roc(as.numeric(testing[,outcomeName])-1, pred_prob[,2])$auc)
  aucs <- round(aucs, digits = 2)
  
  pred <- predict(model, testing[,predictorsNames])
  errors <- which(pred != testing[,outcomeName])

  # save errors to text file
  save_results(outfile = paste(classifier, "txt", sep="."), outdir = paste("output/misclassifications", choice, sep="/"), 
               classifiers = c(classifier), results = errors, expanded = TRUE)
  
  cm <- caret::confusionMatrix(table(data=pred, reference=testing[,outcomeName]), positive="True")
  P <- round(cm$byClass['Pos Pred Value'], digits=2)
  R <- round(cm$byClass['Sensitivity'],  digits=2)
  prec_rec <- c(prec_rec, paste("P=", P, ", R=", R, sep=""))
  # save cm to text file
  save_results(outfile = paste(classifier, "txt", sep="."), outdir = paste("output/cm", choice, sep="/"), 
               classifiers = c(classifier), results = cm, expanded = TRUE)
  scalar_metrics(predictions=pred, truth=testing[,outcomeName], 
                 outdir=paste("output/scalar", choice, sep="/"), outfile=paste(classifier, "txt", sep = "."))
}

# finally, save all models predictions to text file ... 
save_results(outfile = paste(choice, "txt", sep="."), outdir = "output/predictions", 
             classifiers = classifiers, results = predictions, expanded = FALSE)

# and plot ROC curve
line_types <- 1:length(classifiers)
g_col <- gray.colors(
  n = length(classifiers),
  start = 0.3,
  end = 0.8,
  gamma = 2.2,
  alpha = NULL
)
g_col <- rainbow(length(classifiers))

if(!exists("plot_curve", mode="function")) 
  source(paste(getwd(), "lib/plot_curve.R", sep="/"))

op <- par(no.readonly=TRUE) #this is done to save the default settings
plot_dir <- paste("output/plots", choice, sep = "/")
if(!dir.exists(plot_dir))
  dir.create(plot_dir, showWarnings = FALSE, recursive = TRUE, mode = "0777")

tiff(filename=paste(plot_dir, paste(choice, "roc_plot.tiff", sep="_"), sep = "/"),
    type = "cairo", compression = "none", width = 600, height = 600)
plot_curve(predictions=predictions, classifiers=classifiers, 
           colors=g_col, line_type=line_types, 
           x_label="fpr", y_label="tpr", leg_pos="bottomright", plot_abline=TRUE, 
           leg_title="", main_title="", leg_horiz=FALSE, aucs=aucs)
dev.off()
par(op) #re-set the plot to the default settings
