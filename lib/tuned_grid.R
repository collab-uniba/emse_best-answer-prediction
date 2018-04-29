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