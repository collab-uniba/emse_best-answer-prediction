# enable commandline arguments from script launched using Rscript
args<-commandArgs(TRUE)
run <- args[1]
run <- ifelse(is.na(run), 1, run)

# set the random seed, held constant for the current run
seeds <- readLines("seeds.txt")
seed <- ifelse(length(seeds[run]) == 0, sample(1:1000, 1), seeds[as.integer(run)])
set.seed(seed)

# saves that script start time
date_time <- ifelse(is.na(args[2]), format(Sys.time(), "%Y-%m-%d_%H.%M"), args[2])

# creates current output directory for current execution
output_dir <- paste("output", date_time, sep="/")
if(!dir.exists(output_dir))
  dir.create(output_dir, showWarnings = FALSE, recursive = TRUE, mode = "0777")

# these params always exist if launched by the bash script run-tuning.sh
models_file <- ifelse(is.na(args[3]), "models/models1.txt", args[3])
csv_file <- ifelse(is.na(args[4]), "input/test.csv", args[4])

# logs errors to file
 error_file <- paste(date_time, "log", sep = ".")
log.error <- function() {
  cat(geterrmessage(), file=paste(output_dir, error_file, sep = "/"), append=TRUE)
}
options(show.error.locations=TRUE)
options(error=log.error)

# library setup, depedencies are handled by R
#library(pROC) # for AUC
library(caret) # for param tuning
library(e1071) # for normality adjustment

# enables multicore parallel processing 
if(!exists("enable_parallel", mode="function")) 
  source(paste(getwd(), "lib/enable_parallel.R", sep="/"))

# comma delimiter
SO <- read.csv(csv_file, header = TRUE, sep=",")

# name of outcome var to be predicted
outcomeName <- "solution"
# list of predictor vars by name
excluded_predictors <- c("answer_uid", "upvotes", "upvotes_rank")
SO <- SO[ , !(names(SO) %in% excluded_predictors)]
predictorsNames <- names(SO[,!(names(SO)  %in% c(outcomeName))]) # removes the var to be predicted from the test set

# convert boolean factors 
SO$has_links<- as.integer(as.logical(SO$has_links))

# first check whether thera are leading and trailing apostrophes around the date_time field
SO$date_time <- gsub("'", '', SO$date_time)
# then convert timestamps into POSIX std time values, then to equivalent numbers
SO$date_time <- as.numeric(as.POSIXct(strptime(SO$date_time, tz="CET", "%Y-%m-%d %H:%M:%S")))

# normality adjustments for indipendent vars (predictors)
# ln(x+1) transformation mitigates skeweness
for (i in 1:length(predictorsNames)){
  SO[,predictorsNames[i]] <- log1p(SO[,predictorsNames[i]])
}
# exclude rows with Na, NaN and Inf (missing values)
SO <- na.omit(SO)
#SO <- SO[complete.cases(SO), ]

# create stratified training and test sets from SO dataset
splitIndex <- createDataPartition(SO[,outcomeName], p = .70, list = FALSE)
training <- SO[splitIndex, ]
testing <- SO[-splitIndex, ]

# remove the large object
rm(SO)
gc()

# 10-fold CV repetitions
fitControl <- trainControl(
  method = "cv",
  number = 10,
  ## repeated ten times, works only with method="repeatedcv", otherwise 1
  repeats = 10,
  #verboseIter = TRUE,
  #savePredictions = TRUE,
  # binary problem
  summaryFunction=twoClassSummary,
  classProbs = TRUE,
  # enable parallel computing if avail
  allowParallel = TRUE,
  returnData = FALSE
  #sampling = "smote"
)

# load all the classifiers to tune
classifiers <- readLines(models_file)

for(i in 1:length(classifiers)){
  nline <- strsplit(classifiers[i], ":")[[1]]
  classifier <- nline[1]
  cpackage <- nline[2]
  # RWeka packages do need parallel computing to be off
  fitControl$allowParallel <- ifelse(!is.na(cpackage) && cpackage == "RWeka", FALSE, TRUE)
  print(paste("Building model for classifier", classifier))

  if(classifier == "gamboost") {
    ## quick fix, has_links predictor causes error
    predictorsNames <- predictorsNames[predictorsNames  != "has_links"] 
    training <- training[ , !(names(training) %in% c("has_links"))]
    testing <- testing[ , !(names(testing) %in% c("has_links"))]
  } 
  
  if(classifier == "xgbTree") {
    xgb_grid <- expand.grid(nrounds = c(50, 100, 150, 200, 250),
                            eta = c(0.1, 0.3, 0.5, 0.7),
                            max_depth = c(1, 2, 3, 4, 5),
                            # defaults, untuned
                            gamma = 0,
                            colsample_bytree = 1,
                            min_child_weight = 1
    )
    time.start <- Sys.time()
    model <- caret::train(solution ~ ., 
                          data = training,
                          method = classifier,
                          trControl = fitControl,
                          tuneGrid = xgb_grid,
                          metric = "ROC",
                          preProcess = c("center", "scale")
    )
    time.end <- Sys.time()
  } 
  else {
    time.start <- Sys.time()
    model <- caret::train(solution ~ ., 
                          data = training,
                          method = classifier,
                          trControl = fitControl,
                          metric = "ROC",
                          preProcess = c("center", "scale"),
                          tuneLength = 5 # five values per param
    )
    time.end <- Sys.time()
  }
  
  # output file for the classifier at nad
  output_file <- paste(output_dir, paste(classifier, "txt", sep="."), sep = "/")
  
  cat("", "===============================\n", file=output_file, sep="\n", append=TRUE)
  cat("Seed:", seed, file=output_file, sep="\n", append=TRUE)
  out <- capture.output(model)
  title = paste(classifier, run, sep = "_run# ")
  cat(title, out, file=output_file, sep="\n", append=TRUE)

  # elapsed time
  time.elapsed <- time.end - time.start
  out <- capture.output(time.elapsed)
  cat("\nElapsed time", out, file=output_file, sep="\n", append=TRUE)
  
  # the highest roc val from train to save
  out <- capture.output(getTrainPerf(model))
  cat("\nHighest ROC value:", out, file=output_file, sep="\n", append=TRUE)
  
  #predictions <- predict(object=model, testing[,predictorsNames], type='prob')

  # computes the scalar metrics
  predictions <- predict(object=model, testing[,predictorsNames], type='raw')
  
  if(!exists("scalar_metrics", mode="function")) 
    source(paste(getwd(), "lib/scalar_metrics.R", sep="/"))
  scalar_metrics(predictions=predictions, truth=testing[,outcomeName], outdir=".", outfile=output_file)
  

  ## === cleanup ===
  # deallocate large objects
  rm(model)
  rm(predictions)
  # unload the package:
  if(!is.na(cpackage))
    detach(name=paste("package", cpackage, sep=":"), unload = TRUE, character.only = TRUE)
  # garbage collection
  gc()
}
