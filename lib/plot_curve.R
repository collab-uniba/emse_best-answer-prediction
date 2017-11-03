# Plot multiple ROC curves with different colors and sytles, and with legend and random guess line

library(ROCR)  # for plotting ROC curves

plot_curve <- function(predictions, classifiers, colors, line_types=1, line_widths=1.8, x_label="fpr", y_label="tpr",
                       leg_pos="bottomright", leg_title="Models", leg_horiz=TRUE, leg_frame='n',
                       plot_abline=TRUE, main_title="", aucs=NULL, pr=NULL){
  par(
    mar = c(5, 5, 2, 2),
    xaxs = "i",
    yaxs = "i",
    cex.axis = 1,
    cex.lab = 1.1,
    pty="s" # square-sized plot
  )
  range = c(0, 1.0)
  
  for(i in 1:length(predictions)) {
    adding <- ifelse(i == 1, FALSE, TRUE)
    perf <- performance(predictions[[i]], y_label, x_label)
    if(x_label=="fpr" && y_label=="tpr")
      plot(main=main_title, perf, add=adding, col = colors[i], 
           lty = line_types[i], lwd = line_widths, xlim=range, ylim=range)
    else if (x_label=="rec" && y_label=="prec")
      PRcurve(main=main_title, predictions[[i]]@predictions,predictions[[i]]@labels, add=adding, col = colors[i], 
               lty = line_types[i], lwd = line_widths, xlim=range, ylim=range)
  }
  
  if(!is.null(aucs)) {
    for (i in 1:length(classifiers)) {
      classifiers[i] <- paste(classifiers[i], " (AUC=", aucs[i] , ")", sep="")
    } 
  } else if(!is.null(pr)) {
    for (i in 1:length(classifiers)) {
      classifiers[i] <- paste(classifiers[i], " (", pr[i] , ")", sep="")
    }
  }
  
  # Add a legend
  legend(
    leg_pos,
    xpd=TRUE,
    #inset = .1,
    inset = c(0,0),
    classifiers,
    title = leg_title,
    horiz = leg_horiz,
    lty = c(1:length(classifiers)),
    lwd = 2.5,
    col = colors,
    cex=0.9, pt.cex = 1, 
    bty = leg_frame,
    box.col = "grey"
  )

  # and random guess line
  if(plot_abline == TRUE)
    abline(a = 0, b = 1, lty = "dotted", lwd = 0.85, col="grey")
}