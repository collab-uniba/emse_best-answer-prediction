# enable commandline arguments from script launched using Rscript
args <- commandArgs(TRUE)
fxlsx <- args[1]
fxlsx <- ifelse(is.na(fxlsx), "output/tuning/aggregate-metrics.xlsx", fxlsx)

library("xlsx")

# load all the classifier tuned
classifiers <- readLines("models/models.txt")

# default runs
runs <- args[2]
runs <- ifelse(is.na(runs), 10, runs)

# descriptive stats starts after the last run
MIN_INDEX <- runs + 1
MAX_INDEX <- runs + 2
MEAN_INDEX <- runs + 3
MEDIAND_INDEX <- runs + 4
STD_INDEX <- runs + 5

# skips the last one, "parameters"
metrics <- c("AUROC", "F1", "G.mean", "Phi", "Balance", "time")
descrip <- c("min", "max", "mean", "median", "std")

for (i in 1:length(classifiers)) {
  nline <- strsplit(classifiers[i], ":")[[1]]
  classifiers[i] <- nline[1]
}

dfm <- as.data.frame(matrix(ncol=length(classifiers), nrow=runs))
dfm = setNames(dfm, classifiers)

for (i in 1:length(classifiers)) {
  classifier <- classifiers[i]
  dat <- read.xlsx(fxlsx, sheetName = classifier)
  dat <- subset(dat, select = AUROC:time)
  metrics_val <- dat[1:runs,]
  descrip_val <- dat[MIN_INDEX:STD_INDEX,]
  AUROCs <- as.numeric(as.character(dat$AUROC[1:runs]))
  dfm[,classifier] <- AUROCs
}


library(ScottKnottESD)
sk <- sk_esd(x = dfm, alpha = .01)
out <- capture.output(sk$groups)
cat("*******  Scott-Knott ESD clusters  *******", out, file="output/tuning/skesd-clusters.txt", sep="\n", append=FALSE)
out <- capture.output(checkDifference(sk$groups, dfm))
cat("\nDifferences", out, file="output/tuning/skesd-clusters.txt", sep="\n", append=TRUE)

#png(filename="output/plots/skesd-clusters.png")
tiff(filename="output/plots/skesd-clusters.tiff", width = 600, height = 600, units = 'px', compression = 'none', res=100)
plot(sk,
     #col=grey.colors(n = max(sk$groups)),
     col=rainbow(max(sk$groups)),
     mm.lty=3,
     las=2,
     rl=FALSE, xlab="", ylab = "AUC", title = "", ylim = c(0,1))
dev.off()

### FIXME
if(!exists("plot_boxplot", mode="function")) 
  source(paste(getwd(), "lib/plot_boxplot.R", sep="/"))

sk$av$model["cluster"] = 0
for (i in 1:length(classifiers)) {
  group <- sk$groups[[i]]
  number <- sk$ord[i]
  name <- sk$nms[number]
  sk$av$model <- within(sk$av$model, cluster[cluster == 0 & variable == name] <- group)
}
sk$av$model$cluster <- as.factor(sk$av$model$cluster)

#png(filename="output/plots/box-plot-skesd.png", width = 700, height = 600,res=100)
tiff(filename="output/plots/box-plot-skesd.tiff", width = 1000, height = 900, compression = 'none', res=100)
# generate box plot from SK test
plot_boxplot(bx_model=sk$av$model, x_lab="", y_lab="AUC", facets=FALSE)
dev.off()

