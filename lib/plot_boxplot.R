# Plot black & white boxplot with errorbar
library(ggplot2)

plot_boxplot <- function(bx_model, x_lab="Classifiers", y_lab="AUC", 
                         colors=c("black", "white"), facets=FALSE, title=""){
  colfunc <- colorRampPalette(colors)
  # col=colfunc(10),
  p <- ggplot(bx_model, aes(x = x, y = y)) +  ggtitle(title) +
    # plot the boxplots
    stat_boxplot(geom = 'errorbar') +
    geom_boxplot() +
    # write a custom xlab
    xlab(x_lab) +
    # wrote a custom ylab
    ylab(y_lab) +
    # swap the axes
    coord_flip() +
    theme_bw() +
    theme(
      #panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      axis.line = element_line(colour = "black"),
      text = element_text(size = 16)
    )
    if(facets == TRUE)
      p <- p + facet_grid(. ~ cluster,  scales = "free")
    return(p)
}