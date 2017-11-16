
### Automated parameter tuning

*** Table 9 (complete). ***

| Prediction model |                     Default parameter configuration                     | Default AUC  performance |    Optimal parameter  configuration   | Optimal AUC  performance | Tuning runtime |
|:----------------:|:-----------------------------------------------------------------------:|:------------------------:|:-------------------------------------:|:------------------------:|:--------------:|
|      xgbTree     |                                   nrounds = 100 max_depth = 1 eta = 0.3 |                          | nrounds = 200 max_depth = 4 eta = 0.1 |                          |     6h 47m     |
|      pcaNNet     |                                                      size = 1 decay = 0 |                          |                                       |                          |                |
|       earth      |                                                nprune = NULL degree = 1 |                          |                                       |                          |                |
|        gbm       | n.trees = 100 interaction.depth = 1 shrinkage = 0.1 n.minobsinnode = 10 |                          |                                       |                          |                |

### Timewise analysis plots
![xgbtree plot](./xgbTree_auc_plot.tiff)

***Fig. 7. Plot of the xgbTree classifier performance (AUC) for the timewise analysis.***

![gbm plot](./gbm_auc_plot.tiff)

***Fig. 7 (addition). Plot of the gbm classifier performance (AUC) for the timewise analysis.***
