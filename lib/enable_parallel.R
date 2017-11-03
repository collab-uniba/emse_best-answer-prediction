# enables multicore parallel processing 

enable_parallel <- function() {
  if(.Platform$OS.type != "windows") { # on unix-like systems
    library(doMC)
    #reads the number of cores
    c <- detectCores()
    registerDoMC(cores = c)
  } else { # on windows systems
    library(doParallel)
    cl <- makeCluster(detectCores(), type='PSOCK')
    registerDoParallel(cl)
  }
}