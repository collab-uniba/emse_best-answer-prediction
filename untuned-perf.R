# This file computes the AUC performance for the selected model at default param configuration.
# It uses the same SO subsample used in the tuning stage.

# enable commandline arguments from script launched using Rscript
args <- commandArgs(TRUE)

library(caret)
library(ROCR)
library(pROC)

set.seed(875)

if (!exists("save_results", mode = "function"))
  source(paste(getwd(), "lib/save_results.R", sep = "/"))
if (!exists("scalar_metrics", mode = "function"))
  source(paste(getwd(), "lib/scalar_metrics.R", sep = "/"))
if (!exists("setup_dataframe", mode = "function"))
  source(paste(getwd(), "lib/setup_dataframe.R", sep = "/"))
# enables multicore parallel processing
if (!exists("enable_parallel", mode = "function"))
  source(paste(getwd(), "lib/enable_parallel.R", sep = "/"))

default_grid <- function(classifier, dfm = NULL) {
  grid <- NULL
  if (classifier == "xgbTree") {
    grid <-  data.frame(
      nrounds = 100,
      max_depth = 1,
      eta = 0.3,
      # untuned
      gamma = 0,
      colsample_bytree = 1,
      min_child_weight = 1,
      subsample = 1
    )
  }
  else if (classifier == "gbm") {
    grid <-  data.frame(
      n.trees = 100,
      interaction.depth = 1,
      shrinkage = 0.1,
      n.minobsinnode = 10
    )
  }
  else if (classifier == "pcaNNet") {
    grid <-  data.frame(size = 1, decay = 0)
  }
  else if (classifier == "earth") {
    grid <-  data.frame(nprune = 1,  # it should be NULL
                        degree = 1)
  }
  else if (classifier == "gamboost") {
    grid <-  data.frame(mstop = 100, prune = 'no')
  }
  else if (classifier == "nnet") {
    # size has no default value, so we use the smallest admissible one
    grid <-  data.frame(size = 9, decay = 0)
  }
  else if (classifier == "LMT") {
    # iter has no default value, so we use the smallest admissible one
    grid <-  data.frame(iter = 1)
  }
  else if (classifier == "avNNet") {
    # size and decay have no default values, so we use the smallest admissible ones
    grid <-  data.frame(bag = FALSE,
                        size = 1,
                        decay = 0)
  }
  else if (classifier == "C5.0") {
    # model has no default value, so we use the first admissible one
    grid <-  data.frame(trials = 1,
                        model = 'trees',
                        winnow = FALSE)
  }
  else if (classifier == "AdaBoost.M1") {
    # maxdepth = #classes
    grid <-
      data.frame(mfinal = 100,
                 maxdepth = 2,
                 coeflearn = 'Breiman')
  }
  else if (classifier == "multinom") {
    grid <-  data.frame(decay = 0)
  }
  else if (classifier == "mlpWeightDecay") {
    grid <-  data.frame(decay = 0, size = 5)
  }
  else if (classifier == "nb") {
    # adjust has no default value, so we use the first admissible one
    grid <-  data.frame(fL = 0,
                        usekernel = FALSE,
                        adjust = 0)
  }
  else if (classifier == "mlp") {
    # adjust has no default value, so we use the first admissible one
    grid <-  data.frame(size = 5)
  }
  else if (classifier == "fda") {
    grid <-  data.frame(degree = 1, nprune = 2)
  }
  else if (classifier == "pda") {
    grid <-  data.frame(lambda = 1)
  }
  else if (classifier == "knn") {
    grid <-  data.frame(k = 1)
  }
  else if (classifier == "LogitBoost") {
    # default is # column of the dataframe
    grid <-  data.frame(nIter = ncol(dfm))
  }
  else if (classifier == "J48") {
    grid <-  data.frame(C = .25,
                        # untuned
                        M = 2)
  }
  else if (classifier == "rpart") {
    grid <-  data.frame(cp = 0)
  }
  else if (classifier == "svmLinear") {
    grid <-  data.frame(C = 0.1)
  }
  else if (classifier == "JRip") {
    grid <-  data.frame(NumOpt = 2,
                        # untuned
                        NumFolds = 3,
                        MinWeights = 2.0)
  }
  return(grid)
}

# name of outcome var to be predicted
outcomeName <- "solution"
# list of predictor vars by name
excluded_predictors <-
  c(
    "resolved",
    "answer_uid",
    "question_uid",
    "views",
    "views_rank",
    "has_code_snippet",
    "has_tags",
    "loglikelihood_descending_rank",
    "F.K_descending_rank"
  )

# load dataset
csv_file <- ifelse(is.na(args[1]), "input/esej_features_341k.csv", args[1])
temp <- read.csv(csv_file, header = TRUE, sep = ",")
temp <-
  setup_dataframe(
    dataframe = temp,
    outcomeName = outcomeName,
    excluded_predictors = excluded_predictors,
    time_format = "%Y-%m-%d %H:%M:%S",
    normalize = FALSE
  )
so <- temp[[1]]
soPredictorsNames <- temp[[2]]
splitIndex <-
  createDataPartition(so[, outcomeName], p = .70, list = FALSE)
soTraining <- so[splitIndex,]
soTesting <- so[-splitIndex,]

# remove large unused objects from memory
rm(so)
rm(temp)
# garbage collection
gc()

models_file <-
  ifelse(is.na(args[2]), "models/models.txt", args[2])
classifiers <- readLines(models_file)

dataset <- c("so")

# 10-fold CV repetitions
fitControl <- trainControl(
  method = "none",
  verboseIter = FALSE,
  #savePredictions = TRUE,
  # binary problem
  summaryFunction = twoClassSummary,
  classProbs = TRUE,
  # enable parallel computing if avail
  allowParallel = TRUE,
  returnData = FALSE,
  preProcOptions = c("center", "scale")
)

for (j in 1:length(dataset)) {
  predictions <- c()
  cmatrices <- c()
  aucs <- c()
  prec_rec <- c()
  
  training <- paste(dataset[j], "Training", sep = "")
  training <- eval(parse(text = training))
  testing <- paste(dataset[j], "Testing", sep = "")
  testing <- eval(parse(text = testing))
  predictorsNames <- paste(dataset[j], "PredictorsNames", sep = "")
  predictorsNames <- eval(parse(text = predictorsNames))
  
  print(paste("Assessing untuned performance on dataset", dataset[j]))
  
  # load all the classifiers to test
  for (i in 1:length(classifiers)) {
    nline <- strsplit(classifiers[i], ":")[[1]]
    classifier <- nline[1]
    classifiers[i] <- classifier
    
    print(paste("Testing performance of classifier", classifier))
    
    if(classifier == "gamboost") {
      ## quick fix, has_links predictor causes error
      predictorsNames <- predictorsNames[predictorsNames  != "has_links"] 
      #SO <- SO[ , !(names(SO) %in% c("has_links"))]
      training <- training[ , !(names(training) %in% c("has_links"))]
      testing <- testing[ , !(names(testing) %in% c("has_links"))]
    } 
    
    model <- caret::train(
      solution ~ .,
      data = training,
      method = classifier,
      trControl = fitControl,
      metric = "ROC",
      tuneGrid = default_grid(classifier, training)
      #preProcess = c("center") , #"scale")
      #tuneLength = 5 # values per param
    )
    
    pred_prob <-
      predict(model, testing[, predictorsNames], type = 'prob')
    model.prediction_prob <-
      ROCR::prediction(pred_prob[, 2], testing[, outcomeName])
    predictions <- c(predictions, model.prediction_prob)
    aucs <-
      c(aucs, roc(as.numeric(testing[, outcomeName]) - 1, pred_prob[, 2])$auc)
    aucs <- round(aucs, digits = 2)
  }
  
}

# finally, save all models predictions to text file ...
save_results(
  outfile = paste("AUC-all-models", "txt", sep = "."),
  outdir = "output/untuned",
  classifiers = classifiers,
  results = aucs,
  expanded = FALSE
)
