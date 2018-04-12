# Wilcoxon signed-rank test
# check if any difference exist between cross-platform and within-platform
# predictions models.
# Also, effect size (delta) is computed to measure that difference.

require(effsize)

print("============= cross vs within")

print("gbm - F")
cross_gbm_F <- c(0.82, 0.80, 0.72, 0.80)
within_gbm_F <- c(0.95, 0.93, 0.92, 0.96)
W = wilcox.test(cross_gbm_F, within_gbm_F, alternative = "two.sided", 
                paired = TRUE, correct = TRUE, conf.level = 0.95, exact = FALSE)
print(paste("W =",W$statistic))
print(paste("p =",W$p.value))

effsize = cohen.d(cross_gbm_F, within_gbm_F, paired=TRUE)
print(paste("d =", effsize))

print("gbm - G")
cross_gbm_G <- c(0.65, 0.65, 0.65, 0.65)
within_gbm_G <- c(0.37, 0.44, 0.89, 0.13)
W = wilcox.test(cross_gbm_G, within_gbm_G, alternative = "two.sided", 
                paired = TRUE, correct = TRUE, conf.level = 0.95, exact = FALSE)
print(paste("W =",W$statistic))
print(paste("p =",W$p.value))

effsize = cohen.d(cross_gbm_G, within_gbm_G, paired=TRUE)
print(paste("d =", effsize$estimate))

print("gbm - AUC")
cross_gbm_AUC <- c(0.73, 0.71, 0.71, 0.71)
within_gbm_AUC <- c(0.75, 0.83, 0.96, 0.77)
W = wilcox.test(cross_gbm_AUC, within_gbm_AUC, alternative = "two.sided", 
                paired = TRUE, correct = TRUE, conf.level = 0.95, exact = FALSE)
print(paste("W =",W$statistic))
print(paste("p =",W$p.value))

effsize = cohen.d(cross_gbm_AUC, within_gbm_AUC, paired=TRUE)
print(paste("d =", effsize$estimate))

print("gbm - Balance")
cross_gbm_Bal <- c(0.64, 0.65, 0.65, 0.65)
within_gbm_Bal <- c(0.39, 0.43, 0.89, 0.30)
W = wilcox.test(cross_gbm_Bal, within_gbm_Bal, alternative = "two.sided", 
                paired = TRUE, correct = TRUE, conf.level = 0.95, exact = FALSE)
print(paste("W =",W$statistic))
print(paste("p =",W$p.value))

effsize = cohen.d(cross_gbm_Bal, within_gbm_Bal, paired=TRUE)
print(paste("d =", effsize$estimate))

######

print("xgbTree - F")
cross_xgbtree_F <- c(0.86, 0.85, 0.66, 0.84)
within_xgbtree_F <- c(0.95, 0.95, 0.93, 0.96)
W = wilcox.test(cross_xgbtree_F, within_xgbtree_F, alternative = "two.sided", 
                paired = TRUE, correct = TRUE, conf.level = 0.95, exact = FALSE)
print(paste("W =",W$statistic))
print(paste("p =",W$p.value))

effsize = cohen.d(cross_xgbtree_F, within_xgbtree_F, paired = TRUE)
print(paste("d =", effsize$estimate))

print("xgbTree - G")
cross_xgbtree_G <- c(0.62, 0.63, 0.65, 0.62)
within_xgbtree_G <- c(0.32, 0.52, 0.90, 0.12)
W = wilcox.test(cross_xgbtree_G, within_xgbtree_G, alternative = "two.sided", 
                paired = TRUE, correct = TRUE, conf.level = 0.95, exact = FALSE)
print(paste("W =",W$statistic))
print(paste("p =",W$p.value))

effsize = cohen.d(cross_xgbtree_G, within_xgbtree_G, paired = TRUE)
print(paste("d =", effsize$estimate))

print("xgbTree - AUC")
cross_xgbtree_AUC <- c(0.67, 0.71, 0.74, 0.68)
within_xgbtree_AUC <- c(0.74, 0.83, 0.97, 0.78)
W = wilcox.test(cross_xgbtree_AUC, within_xgbtree_AUC, alternative = "two.sided", 
                paired = TRUE, correct = TRUE, conf.level = 0.95, exact = FALSE)
print(paste("W =",W$statistic))
print(paste("p =",W$p.value))

effsize = cohen.d(cross_xgbtree_AUC, within_xgbtree_AUC, paired = TRUE)
print(paste("d =", effsize$estimate))

print("xgbTree - Balance")
cross_xgbtree_Bal <- c(0.61, 0.62, 0.64, 0.62)
within_xgbtree_Bal <- c(0.37, 0.48, 0.90, 0.30)
W = wilcox.test(cross_xgbtree_Bal, within_xgbtree_Bal, alternative = "two.sided", 
                paired = TRUE, correct = TRUE, conf.level = 0.95, exact = FALSE)
print(paste("W =",W$statistic))
print(paste("p =",W$p.value))

effsize = cohen.d(cross_xgbtree_Bal, within_xgbtree_Bal, paired = TRUE)
print(paste("d =", effsize$estimate))

print("============= cross vs baseline")

baseline_F <- c(0.85, 0.80, 0.58, 0.80)
baseline_G <- c(0.95, 0.93, 0.84, 0.96)
baseline_Bal <- c(0.36, 0.38, 0.46, 0.34)
baseline_AUC <- c(0.50, 0.50, 0.50, 0.50)

print("gbm - F")
W = wilcox.test(cross_gbm_F, baseline_F, alternative = "two.sided", 
                paired = FALSE, correct = TRUE, conf.level = 0.95, exact = FALSE)
print(paste("W =",W$statistic))
print(paste("p =",W$p.value))

effsize = cohen.d(cross_gbm_F, baseline_F, paired=TRUE)
print(paste("d =", effsize$estimate))

print("gbm - G")
W = wilcox.test(cross_gbm_G, baseline_G, alternative = "two.sided", 
                paired = FALSE, correct = TRUE, conf.level = 0.95, exact = FALSE)
print(paste("W =",W$statistic))
print(paste("p =",W$p.value))

effsize = cohen.d(cross_gbm_G, baseline_G, paired=TRUE)
print(paste("d =", effsize$estimate))

print("gbm - AUC")
W = wilcox.test(cross_gbm_AUC, baseline_AUC, alternative = "two.sided", 
                paired = FALSE, correct = TRUE, conf.level = 0.95, exact = FALSE)
print(paste("W =",W$statistic))
print(paste("p =",W$p.value))

effsize = cohen.d(cross_gbm_AUC, baseline_AUC, paired=TRUE)
print(paste("d =", effsize$estimate))

print("gbm - Balance")
W = wilcox.test(cross_gbm_Bal, baseline_Bal, alternative = "two.sided", 
                paired = FALSE, correct = TRUE, conf.level = 0.95, exact = FALSE)
print(paste("W =",W$statistic))
print(paste("p =",W$p.value))

effsize = cohen.d(cross_gbm_Bal, baseline_Bal, paired=TRUE)
print(paste("d =", effsize$estimate))

#####

print("xgbTree - F")
W = wilcox.test(cross_xgbtree_F, baseline_F, alternative = "two.sided", 
                paired = FALSE, correct = TRUE, conf.level = 0.95, exact = FALSE)
print(paste("W =",W$statistic))
print(paste("p =",W$p.value))

effsize = cohen.d(cross_xgbtree_F, baseline_F, paired = TRUE)
print(paste("d =", effsize$estimate))

print("xgbTree - G")
W = wilcox.test(cross_xgbtree_G, baseline_G, alternative = "two.sided", 
                paired = FALSE, correct = TRUE, conf.level = 0.95, exact = FALSE)
print(paste("W =",W$statistic))
print(paste("p =",W$p.value))

effsize = cohen.d(cross_xgbtree_G, baseline_G, paired = TRUE)
print(paste("d =", effsize$estimate))

print("xgbTree - AUC")
W = wilcox.test(cross_xgbtree_AUC, baseline_AUC, alternative = "two.sided", 
                paired = FALSE, correct = TRUE, conf.level = 0.95, exact = FALSE)
print(paste("W =",W$statistic))
print(paste("p =",W$p.value))

effsize = cohen.d(cross_xgbtree_AUC, baseline_AUC, paired = TRUE)
print(paste("d =", effsize$estimate))

print("xgbTree - Balance")
W = wilcox.test(cross_xgbtree_Bal, baseline_Bal, alternative = "two.sided", 
                paired = FALSE, correct = TRUE, conf.level = 0.95, exact = FALSE)
print(paste("W =",W$statistic))
print(paste("p =",W$p.value))

effsize = cohen.d(cross_xgbtree_Bal, baseline_Bal, paired = TRUE)
print(paste("d =", effsize$estimate))

# cross_G = c(cross_gbm_G, cross_xgbtree_G)
# cross_F = c(cross_gbm_F, cross_xgbtree_F)
# cross_AUC = c(cross_gbm_AUC, cross_xgbtree_AUC)
# cross_Bal = c(cross_gbm_Bal, cross_xgbtree_Bal)
# 
# within_G = c(within_gbm_G, within_xgbtree_G)
# within_F = c(within_gbm_F, within_xgbtree_F)
# within_AUC = c(within_gbm_AUC, within_xgbtree_AUC)
# within_Bal = c(within_gbm_Bal, within_xgbtree_Bal)
# 
# 
# W = wilcox.test(cross_G, within_G, alternative = "two.sided",
#                 paired = FALSE, conf.level = 0.95, exact = FALSE)
# print(paste("W =",W$statistic))
# print(paste("p =",W$p.value))
# 
# effsize = cohen.d(cross_G, within_G, paired = FALSE)
# print(paste("d =", effsize$estimate))
