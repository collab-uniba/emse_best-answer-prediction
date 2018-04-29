library(caret)
set.seed(875)

if(!exists("get_grid", mode="function")) 
  source(paste(getwd(), "lib/tuned_grid.R", sep="/"))

temp <- read.csv('input/so_341k.csv', header = TRUE, sep=",")
excluded_predictors <- c("answer_uid", "question_uid", "views", "views_rank",
                         "has_code_snippet", "has_tags", "loglikelihood_descending_rank", "F.K_descending_rank")
so_answers <- setup_dataframe(dataframe = temp, outcomeName = outcomeName, excluded_predictors = excluded_predictors,
                        time_format="%Y-%m-%d %H:%M:%S", normalize = FALSE)
so <- so_answers[[1]]
so <- so[so$answers_count==1, ]
dim <- nrow(so)
dim
res <- nrow(so[so$solution == "True",])
res
unres <- nrow(so[so$solution == "False",])
unres
print((unres*100)/dim)

predictorsNames <- so_answers[[2]]
splitIndex <- createDataPartition(so[,outcomeName], p = .70, list = FALSE)
soTraining <- so[splitIndex, ]
soTesting <- so[-splitIndex, ]

# name of outcome var to be predicted
outcomeName <- "solution"
classifiers <- readLines("models/top-models.txt")
predictions <- c()
aucs <- c()
rocobjs_one_answer <- c()
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
  rocobjs_one_answer[i] <- list(rocobj)
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

tiff(filename=paste(plot_dir, paste("so", "roc_plot_one_answer.tiff", sep="_"), sep = "/"), 
     type = get_graphic_type(), compression = "none", width = 2000, height = 2000, pointsize = 20, res=200)
plot_curve(predictions= predictions,
           classifiers=classifiers, 
           colors=g_col, line_type=line_types, 
           x_label="fpr", y_label="tpr", leg_pos="bottomright", plot_abline=TRUE, 
           leg_title="", main_title="", leg_horiz=FALSE, aucs=aucs)
dev.off()
par(op) #re-set the plot to the default settings
