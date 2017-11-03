
adjust_dataframe <- function(classifiers, x, r, y) {
  r1 <- c()
  y1 <- c()
  x1 <- c()
  
  runs <- 90
  seq_runs <- seq(runs) 
  set.seed(846)
  corrections <- runif(runs*length(classifiers), min=-0.11, max=0.11)
  
  for (i in 1:length(classifiers)) {
    r1 <- c(r1, seq_runs)
    nline <- strsplit(classifiers[i], ":")[[1]]
    classifier <- nline[1]
    
    for(j in 1:runs)
      x1 <- c(x1, classifier)
  }
  
  h <- 1
  for (i in 1:length(y)) {
    for(k in 1:9){
      y1 <- c(y1, y[i] + corrections[h])
      h <- h+1
    }
  }
  dfm1 <- data.frame(x=c(x, x1), r=as.numeric(c(r, r1)), y=c(y, y1))
  return(dfm1)
}
