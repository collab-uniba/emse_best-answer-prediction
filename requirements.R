print("Checking the required packages... won't be re-installed if already present.")

# checks if multicore parallel package can be enabled
if(.Platform$OS.type == "unix") {
  if(!require("doMC", quietly = TRUE)){
    install.packages(c("doMC"), dependencies = c("Imports", "Depends"), repos = "http://cran.mirror.garr.it/mirrors/CRAN/")
  }
} else if (.Platform$OS.type == "windows") {
  if(!require("doParallel", quietly = TRUE)){
    install.packages(c("doParallel"), dependencies = c("Imports", "Depends"), repos = "http://cran.mirror.garr.it/mirrors/CRAN/")
  }
}

# checks if RJava is present
# if not, it has to be installed manually , depending on OS
# on Mac OS X and RStudio, you may require the following to load rJava:
# sudo ln -f -s $(/usr/libexec/java_home)/jre/lib/server/libjvm.dylib /usr/local/lib
if(!require("rJava", quietly = TRUE)) {
  print("Please, Install rJava package manually and re-run.")
} else if (!require("RWeka", quietly = TRUE) || !require("RWekajars", quietly = TRUE)) {
  install.packages(c("RWeka", "RWekajars"), dependencies = c("Imports", "Depends"), repos = "http://cran.mirror.garr.it/mirrors/CRAN/")
}

if(!require("xlsx", quietly = TRUE)){
  install.packages(c("xlsx", "xlsxjars"), dependencies = c("Imports", "Depends"), repos = "http://cran.mirror.garr.it/mirrors/CRAN/")
}

if(!require("ScottKnottESD", quietly = TRUE)){
  install.packages("ScottKnottESD", dependencies = c("Imports", "Depends"), repos = "http://cran.mirror.garr.it/mirrors/CRAN/")
}

if(!require("Boruta", quietly = TRUE)){
  install.packages("Boruta", dependencies = c("Imports", "Depends"), repos = "http://cran.mirror.garr.it/mirrors/CRAN/")
}

if(!require("FSelector", quietly = TRUE)){
  install.packages("FSelector", dependencies = c("Imports", "Depends"), repos = "http://cran.mirror.garr.it/mirrors/CRAN/")
}

if(!require("ROCR", quietly = TRUE)){
  install.packages("ROCR", dependencies = c("Imports", "Depends"), repos = "http://cran.mirror.garr.it/mirrors/CRAN/")
}

if(!require("DMwR", quietly = TRUE)){
  install.packages(c("TTR", "DMwR"), dependencies = c("Imports", "Depends"), repos = "http://cran.mirror.garr.it/mirrors/CRAN/")
}

# gpls is not available anymore in CRAN as of R 3.3.0
if(!require("gpls", quietly = TRUE)){
  source("https://bioconductor.org/biocLite.R")
  biocLite("gpls")
}

# from https://github.com/tobigithub/caret-machine-learning/wiki/caret-ml-setup
# installs most of the 340 caret dependencies but not all of them
mostP <- c("AppliedPredictiveModeling", "ggplot2", "pROC",
           "data.table", "plyr", "knitr", "shiny", "xts", "lattice", "e1071",
            "klaR", "earth", "nnet", "RSNNS", "MASS", "mda", "rpart", "kernlab", 
            "randomForest", "ipred", "gbm", "caTools", "xgboost", "C50")
install.packages(mostP, dependencies = c("Imports", "Depends"), repos = "http://cran.mirror.garr.it/mirrors/CRAN/")
install.packages("party", repos = "http://cran.mirror.garr.it/mirrors/CRAN/")
install.packages("mboost", repos = "http://cran.mirror.garr.it/mirrors/CRAN/")
install.packages("adabag", repos = "http://cran.mirror.garr.it/mirrors/CRAN/")
install.packages("adabag", repos = "http://cran.mirror.garr.it/mirrors/CRAN/")
install.packages(c("caret", "car", "pbkrtest", "lme4"), repos = "http://cran.mirror.garr.it/mirrors/CRAN/")

print("Done.")

# non optimized (unsupported by caret)

# to load in case of ADT:
## WPM("install-package", "alternatingDecisionTrees")
## WPM("load-package", "alternatingDecisionTrees")
## ADT <- make_Weka_classifier("weka/classifiers/trees/ADTree")
## model <- ADT(solution ~ ., data = training)

#SMO:
## see http://www.inside-r.org/packages/cran/RWeka/docs/SMO
## model<-SMO(solution ~ ., data = training, control = Weka_control(K =list("weka.classifiers.functions.supportVector.RBFKernel", G = 2)))


# build a weka classifier from WPM
# make_Weka_classifier <- function(classifier) {
#   model <- NaN
#   require("RWeka")
#   if(classifier == "ADT") {
#     WPM("install-package", "alternatingDecisionTrees")
#     WPM("load-package", "alternatingDecisionTrees")
#     ADT <- make_Weka_classifier("weka/classifiers/trees/ADTree")
#     model <- ADT(solution ~ ., data = training)
#   } else if (classifier == "SMO") {
#     model<-SMO(solution ~ ., 
#                data = training, 
#                control = Weka_control(K =list("weka.classifiers.functions.supportVector.RBFKernel", 
#                                               G = 2))
#     )
#   }
#   
#   return(model)
# }
