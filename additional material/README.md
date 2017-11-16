
### Automated parameter tuning

***Table 9 (complete). Default and optimal parameter configuration with AUC performance and overall tuning runtime (in hours) for the 26 models.***

| Prediction model |                        Default parameter configuration                        | Default AUC  performance |                        Optimal parameter  configuration                       | Optimal AUC  performance | Tuning runtime |
|:----------------:|:-----------------------------------------------------------------------------:|:------------------------:|:-----------------------------------------------------------------------------:|:------------------------:|:--------------:|
|      xgbTree     | `nrounds = 100,  max_depth = 1,  eta = 0.3`                                   |                          | `nrounds = 200,  max_depth = 4,  eta = 0.1`                                   |            .94           |     6h 47m     |
|      pcaNNet     | `size = 1, decay = 0`                                                         |                          | `size = 7, decay = 0.1`                                                       |            .93           |     2h 20m     |
|       earth      | `nprune = NULL, degree = 1`                                                   |                          | `nprune = 15, degree = 1`                                                     |            .93           |     3h 53m     |
|        gbm       | `n.trees = 100, interaction.depth = 1,  shrinkage = 0.1, n.minobsinnode = 10` |                          | `n.trees = 250, interaction.depth = 3,  shrinkage = 0.1, n.minobsinnode = 10` |            .94           |     8h 44m     |
|     gabmboost    |                                                                               |                          |                                                                               |                          |                |
|       nnet       |                                                                               |                          |                                                                               |                          |                |
|        LMT       |                                                                               |                          |                                                                               |                          |                |
|      avNNet      |                                                                               |                          |                                                                               |                          |                |
|       C5.0       |                                                                               |                          |                                                                               |                          |                |
|     AdaBoost     |                                                                               |                          |                                                                               |                          |                |
|     multinom     |                                                                               |                          |                                                                               |                          |                |
|        rf        |                                                                               |                          |                                                                               |                          |                |
|        lda       |                                                                               |                          |                                                                               |                          |                |
|  mlpWeightDecay  |                                                                               |                          |                                                                               |                          |                |
|        glm       |                                                                               |                          |                                                                               |                          |                |
|        nb        |                                                                               |                          |                                                                               |                          |                |
|        mlp       |                                                                               |                          |                                                                               |                          |                |
|        fda       |                                                                               |                          |                                                                               |                          |                |
|        pda       |                                                                               |                          |                                                                               |                          |                |
|        knn       |                                                                               |                          |                                                                               |                          |                |
|     LogiBoost    |                                                                               |                          |                                                                               |                          |                |
|      treebag     |                                                                               |                          |                                                                               |                          |                |
|        J48       |                                                                               |                          |                                                                               |                          |                |
|       rpart      |                                                                               |                          |                                                                               |                          |                |
|     svmLinear    |                                                                               |                          |                                                                               |                          |                |
|       JRip       |                                                                               |                          |                                                                               |                          |                |

### Timewise analysis plots
![xgbtree plot](./xgbTree_auc_plot.tiff)

***Fig. 7. Plot of the xgbTree classifier performance (AUC) for the timewise analysis.***

![gbm plot](./gbm_auc_plot.tiff)

***Fig. 7 (addition). Plot of the gbm classifier performance (AUC) for the timewise analysis.***
