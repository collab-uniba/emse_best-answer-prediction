# Script that computes Matthews Correlation Coefficient

mcc <- function (actual, predicted, positive = TRUE, negative = FALSE)
{
  # handles zero denominator and verflow error on large-ish products in denominator.
  #
  # actual = vector of true outcomes, 1 or True = Positive, 0 or False = Negative
  # predicted = vector of predicted outcomes, 1 or True = Positive, 0 or False = Negative
  # function returns MCC
  
  TP <- sum(actual == positive & predicted == positive)
  TN <- sum(actual == negative & predicted == negative)
  FP <- sum(actual == negative & predicted == negative)
  FN <- sum(actual == positive & predicted == negative)
  
  sum1 <- TP+FP; sum2 <-TP+FN ; sum3 <-TN+FP ; sum4 <- TN+FN;
  denom <- as.double(sum1)*sum2*sum3*sum4 # as.double to avoid overflow error on large products
  
  if (any(sum1==0, sum2==0, sum3==0, sum4==0)) {
    denom <- 1
  }
  
  mcc <- ((TP*TN)-(FP*FN)) / sqrt(denom)
  return(mcc)
}
