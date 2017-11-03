
setup_dataframe <- function(dataframe, outcomeName, excluded_predictors, time_format="%Y-%m-%d %H:%M:%S", 
                            normalize=TRUE, na_omit=TRUE) {
  dataframe <- dataframe[ , !(names(dataframe) %in% excluded_predictors)]
  predictorsNames <- names(dataframe[,!(names(dataframe)  %in% c(outcomeName))]) # removes the var to be predicted from the test set
  
  # convert boolean factors 
  tryCatch({
    dataframe$has_links<- as.integer(as.logical(dataframe$has_links))
  }, error = function(e) {
    # ignore
  })
  tryCatch({
    dataframe$has_code_snippet<- as.integer(as.logical(dataframe$has_code_snippet))
  }, error = function(e) {
    # ignore
  })
  tryCatch({
    dataframe$has_tags<- as.integer(as.logical(dataframe$has_tags))
  }, error = function(e) {
    # ignore
  })
  
  tryCatch({
    dataframe$F.K<- numeric(dataframe$F.K)
  }, error = function(e) {
    # ignore
  })
  
  # first check whether thera are leading and trailing apostrophes around the date_time field
  dataframe$date_time <- gsub("'", '', dataframe$date_time)
  # then convert timestamps into POSIX std time values, then to equivalent numbers
  dataframe$date_time <- as.numeric(as.POSIXct(strptime(dataframe$date_time, tz="CET", time_format)))
  
  if(normalize == TRUE) {
    if(!require(e1071))
      library(e1071) # for normality adjustment
    # normality adjustments for indipendent vars (predictors)
    # ln(x+1) transformation mitigates skeweness
    for (i in 1:length(predictorsNames)){
      dataframe[,predictorsNames[i]] <- log1p(dataframe[,predictorsNames[i]])
    }
  }
  
  if(na_omit == TRUE) {
    # exclude rows with Na, NaN and Inf (missing values)
    dataframe <- na.omit(dataframe)
  }
  
  return(list(dataframe, predictorsNames))
}