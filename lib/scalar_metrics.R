library(caret)

scalar_metrics <- function(predictions, truth, outdir="output/scalar", outfile) {
  if(!dir.exists(outdir))
    dir.create(outdir, showWarnings = FALSE, recursive = TRUE, mode = "0777")
  output_file = paste(outdir, outfile, sep = "/")
  
  CM <- table(data=predictions, reference=truth)
  out <- capture.output(CM)
  cat("\nConfusion Matrix:\n", out, file=output_file, sep="\n", append=FALSE)
  
  TP <- as.numeric(CM[1])
  FP <- as.numeric(CM[3])
  FN <- as.numeric(CM[2])
  TN <- as.numeric(CM[4])
  precision <- posPredValue(predictions, testing[,outcomeName], positive="True")
  recall <- sensitivity(predictions, testing[,outcomeName], positive="True")
  TNr <- specificity(predictions, testing[,outcomeName], positive="True")
  TPr <- recall
  FPr <- FP / (FP + TN)
  
  F1 <- (2 * precision * recall) / (precision + recall)
  out <- paste("F-measure =", F1)
  cat("", out, file=output_file, sep="\n", append=TRUE)
  G <- sqrt(TPr * TNr)
  out <- paste("G-mean =", G)
  cat("", out, file=output_file, sep = "\n", append = TRUE)
  M <- ((TP*TN) - (FP*FN)) / sqrt((TP+FP)*(TP+FN)*(TN+FP)*(TN+FN))
  out <- paste("Matthews phi =", M)
  cat("", out, file=output_file, sep = "\n", append = TRUE)
  B <- 1 - (sqrt((0-FPr)^2 +(1-TPr)^2)/sqrt(2))
  out <- paste("Balance =", B)
  cat("", out, file=output_file, sep = "\n", append = TRUE)
}