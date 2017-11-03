# function to save results to a file
save_results <- function(outfile="results.txt", outdir="output/results", classifiers, results, expanded=FALSE){
  # creates current output directory for current execution
  if(!dir.exists(outdir))
    dir.create(outdir, showWarnings = FALSE, recursive = TRUE, mode = "0777")
  
    f <- paste(outdir, outfile, sep="/")
    
    if(expanded == TRUE) {
      title=paste("\n===========", classifiers[[1]], "============\n", sep = "  ")
      out <- capture.output(results)
      cat(title, out, file=f, sep="\n", append=FALSE)
    }
    else {
      for(i in 1:length(results)) {
        out <- capture.output(results[[i]])
        title=paste("\n===========", classifiers[[i]], "============\n", sep = "  ")
        cat(title, out, file=f, sep="\n", append=ifelse(i==1, FALSE, TRUE))  
      }
    }
}
