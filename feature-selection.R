# enable commandline arguments from script launched using Rscript
args<-commandArgs(TRUE)
# shows error line no.
options(show.error.locations=TRUE)

# files with features
feat_file <- args[1]
feat_file <- ifelse(is.na(feat_file),"input/esej_features_85k.csv", feat_file)
# choice
choice <- args[2]
choice <- ifelse(is.na(choice), "so", choice)
# best k features to select, default 10
k <- args[3]
k <- ifelse(is.na(k), 10, k)

if(choice == "so") {
  sep <- ","
  time_format <- "%Y-%m-%d %H:%M:%S"  
} else if(choice == "docusign") { 
  sep <- ","
  time_format <- "%d/%m/%Y %H:%M:%S"
} else if(choice == "dwolla") { 
  sep <- ";"
  time_format <- "%d/%m/%Y %H:%M"
} else if(choice == "yahoo") { 
  sep <- ";"
  time_format <- "%Y-%m-%d %H:%M:%S"
} else if(choice == "scn") {
  sep <- ","
  time_format <- "%Y-%m-%d %H:%M:%S"
} else { ## assume a test is run without param from command line
  sep <- ","
  time_format <- "%Y-%m-%d %H:%M:%S"
}

# name of outcome var to be predicted
outcomeName <- "solution"
# list of predictor vars by name
# excluded_predictors <- c("resolved", "answer_uid", "question_uid",
#                          "has_code_snippet", "has_tags", "loglikelihood_descending_rank", "F.K_descending_rank")
excluded_predictors <- c("resolved", "answer_uid", "question_uid")

if(!exists("setup_dataframe", mode="function")) 
  source(paste(getwd(), "lib/setup_dataframe.R", sep="/"))
# load the feature file into dataframe dfm 
temp <- read.csv(feat_file, header = TRUE, sep=sep)
temp <- setup_dataframe(dataframe = temp, outcomeName = outcomeName, excluded_predictors = excluded_predictors,
                        time_format=time_format, normalize = FALSE)
dfm <- temp[[1]]
predictorsNames <- temp[[2]]

dfm$solution<- as.integer(as.logical(dfm$solution))

# output file for the classifier at hand
output_dir <- paste("output/feature-selection", choice, sep = "/")
if(!dir.exists(output_dir))
  dir.create(output_dir, showWarnings = FALSE, recursive = TRUE, mode = "0777")
output_file <- paste(output_dir, "feature-subset.txt", sep = "/")

# feature selection through Wrapper algorithm
library("Boruta")
print("Boruta")
# default pValue = 0.01 is used
# try to reduce maxRuns if it takes too long
set.seed(123)
b.fs <- Boruta(solution~., data=dfm, maxRuns = 100, doTrace = 2, holdHistory = TRUE)
out <- capture.output(b.fs)
cat("*******  BORUTA  *******", out, file=output_file, sep="\n", append=FALSE)
out <- capture.output(attStats(b.fs))
cat("", out, file=output_file, sep="\n", append=TRUE)
#plot(b.fs, sort=TRUE)
#plotImpHistory(b.fs)


# feature selection through CFS - Correlation Feature Selection
library("FSelector")

print("CFS")
subset <- cfs(solution~., dfm)
f <- as.simple.formula(subset, outcomeName)
out <- capture.output(f)
cat("\n*******  CFS  *******", out, file=output_file, sep="\n", append=TRUE)

# use Pearson's correlation, requires all data to be continous
weights <- linear.correlation(solution~., data=dfm)
out <- capture.output(weights)
cat("\n*******  Pearson's correlation filter *******", out, file=output_file, sep="\n", append=TRUE)
# select K best attributes
subset <- cutoff.k(weights, k)
out <- capture.output(subset)
cat("", out, file=output_file, sep="\n", append=TRUE)
#f <- as.simple.formula(subset, "solution")
#print(f)
# use Spearman's ro correlation, requires all data to be continous
weights <- rank.correlation(solution~., data=dfm)
out <- capture.output(weights)
cat("\n*******  Spearman's ro correlation filter *******", out, file=output_file, sep="\n", append=TRUE)
# select K best attributes
subset <- cutoff.k(weights, k)
out <- capture.output(subset)
cat("", out, file=output_file, sep="\n", append=TRUE)
#f <- as.simple.formula(subset, "solution")
#print(f)

library(caret)
# calculate correlation matrix
correlationMatrix <- cor(dfm[,predictorsNames])
# summarize the correlation matrix
out <- capture.output(correlationMatrix)
cat("\n*******  Correlation matrix *******", out, file=output_file, sep="\n", append=TRUE)
# find attributes that are highly corrected (ideally >0.75)
highlyCorrelated <- findCorrelation(correlationMatrix, cutoff=0.75, names = TRUE, exact = TRUE)
# print indexes of highly correlated attributes
out <- capture.output(highlyCorrelated)
cat("\n*******  Predictors to remove (cutoff >.75) *******", out, file=output_file, sep="\n", append=TRUE)
