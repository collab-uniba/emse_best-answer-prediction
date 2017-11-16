
### Automated parameter tuning

***Table 9 (complete). Default and optimal parameter configuration with AUC performance and overall tuning runtime (in hours) for the 26 models.***

| Prediction model |                        Default parameter configuration                        | Default AUC  performance |                        Optimal parameter  configuration                       | Optimal AUC  performance | Tuning runtime |
|:----------------:|:-----------------------------------------------------------------------------:|:------------------------:|:-----------------------------------------------------------------------------:|:------------------------:|---------------:|
|      xgbTree     | `nrounds = 100,  max_depth = 1,  eta = 0.3`                                   |                          | `nrounds = 200,  max_depth = 4,  eta = 0.1`                                   |            .94           |        06h 47m |
|      pcaNNet     | `size = 1, decay = 0`                                                         |                          | `size = 7, decay = 0.1`                                                       |            .93           |        02h 20m |
|       earth      | `nprune = NULL, degree = 1`                                                   |                          | `nprune = 15, degree = 1`                                                     |            .93           |        03h 53m |
|        gbm       | `n.trees = 100, interaction.depth = 1,  shrinkage = 0.1, n.minobsinnode = 10` |                          | `n.trees = 250, interaction.depth = 3,  shrinkage = 0.1, n.minobsinnode = 10` |            .94           |        08h 44m |
|     gabmboost    |                                                                               |                          |                                                                               |                          |        02h 06m |
|       nnet       |                                                                               |                          |                                                                               |                          |        25h 10m |
|        LMT       |                                                                               |                          |                                                                               |                          |        75h 54m |
|      avNNet      |                                                                               |                          |                                                                               |                          |        11h 15m |
|       C5.0       |                                                                               |                          |                                                                               |                          |        07h 05m |
|     AdaBoost     |                                                                               |                          |                                                                               |                          |       114h 48m |
|     multinom     |                                                                               |                          |                                                                               |                          |        01h 05m |
|        rf        |                                                                               |                          |                                                                               |                          |        73h 24m |
|        lda       |                                                                               |                          |                                                                               |                          |        00h 06m |
|  mlpWeightDecay  |                                                                               |                          |                                                                               |                          |        85h 18m |
|        glm       |                                                                               |                          |                                                                               |                          |        00h 08m |
|        nb        |                                                                               |                          |                                                                               |                          |        00h 53m |
|        mlp       |                                                                               |                          |                                                                               |                          |        44h 12m |
|        fda       |                                                                               |                          |                                                                               |                          |        01h 34m |
|        pda       |                                                                               |                          |                                                                               |                          |        00h 29m |
|        knn       |                                                                               |                          |                                                                               |                          |       125h 28m |
|     LogiBoost    |                                                                               |                          |                                                                               |                          |        00h 21m |
|      treebag     |                                                                               |                          |                                                                               |                          |        06h 07m |
|        J48       |                                                                               |                          |                                                                               |                          |        01h 30m |
|       rpart      |                                                                               |                          |                                                                               |                          |        00h 12m |
|     svmLinear    |                                                                               |                          |                                                                               |                          |        15h 34m |
|       JRip       |                                                                               |                          |                                                                               |                          |        06h 50m |


### Timewise analysis plots
![xgbtree plot](./xgbTree_auc_plot.tiff)

***Fig. 7. Plot of the xgbTree classifier performance (AUC) for the timewise analysis.***

![gbm plot](./gbm_auc_plot.tiff)

***Fig. 7 (addition). Plot of the gbm classifier performance (AUC) for the timewise analysis.***
