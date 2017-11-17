
### Automated parameter tuning

***Table 9 (complete). Default and optimal parameter configuration with AUC performance and overall tuning runtime (in hours) for the 26 models.***

| Prediction model |                        Default parameter configuration                        | Default AUC  performance |                       Optimal parameter  configuration                       | Optimal AUC  performance | Tuning runtime |
|:----------------:|:-----------------------------------------------------------------------------:|:------------------------:|:----------------------------------------------------------------------------:|:------------------------:|:--------------:|
|      xgbTree     | `nrounds = 100,  max_depth = 1,  eta = 0.3`                                   |                          | `nrounds = 200,  max_depth = 4,  eta = 0.1`                                  |            .94           |     06h 47m    |
|      pcaNNet     | `size = 1, decay = 0`                                                         |                          | `size = 7, decay = 0.1`                                                      |            .93           |     02h 20m    |
|       earth      | `nprune = NULL, degree = 1`                                                   |                          | `nprune = 15, degree = 1`                                                    |            .93           |     03h 53m    |
|        gbm       | `n.trees = 100, interaction.depth = 1,  shrinkage = 0.1, n.minobsinnode = 10` |                          | `n.trees = 250, interaction.depth = 3, shrinkage = 0.1, n.minobsinnode = 10` |            .94           |     08h 44m    |
|     gabmboost    | `mstop = , prune = `                                                          |                          | `mstop = 250, prune = no`                                                    | .88                      |     02h 06m    |
|       nnet       | `size = , decay = `                                                           |                          | `size = 9, decay = 0.1`                                                      | .83                      |     25h 10m    |
|        LMT       | `iter = `                                                                     |                          | `iter = 81`                                                                  | .84                      |     75h 54m    |
|      avNNet      | `bag = , size = , decay = `                                                   |                          | `bag = FALSE, size = 9, decay = 0.1`                                         | .83                      |     11h 15m    |
|       C5.0       | `trials = , model = , winnow = `                                              |                          | `trials = 40, model = rules, winnow = FALSE `                                | .83                      |     07h 05m    |
|     AdaBoost     | `mfinal = 100, maxdepth = , coeflearn = `                                     |                          | `mfinal = 250, maxdepth = 3, coeflearn = Freund`                             | .82                      |    114h 48m    |
|     multinom     | `decay = `                                                                    |                          | `decay = 0`                                                                  | .84                      |     01h 05m    |
|        rf        | `mtry = `                                                                     |                          | `mtry = 6`                                                                   | .84                      |     73h 24m    |
|        lda       | `-`                                                                           |                          | `-`                                                                          | .84                      |     00h 06m    |
|  mlpWeightDecay  | `decay = , size = `                                                           |                          | `decay = 9, size = 1e-04`                                                    | .84                      |     85h 18m    |
|        glm       | `-`                                                                           |                          | `-`                                                                          | .81                      |     00h 08m    |
|        nb        | `fL = , usekernel = , adjust = `                                              |                          | `fL = 0, usekernel = FALSE, adjust = 1`                                      | .81                      |     00h 53m    |
|        mlp       | `size = `                                                                     |                          | `size = 9`                                                                   | .80                      |     44h 12m    |
|        fda       | `degree = , nprune = `                                                        |                          | `degree = 1, nprune = 15`                                                    | .81                      |     01h 34m    |
|        pda       | `lambda = `                                                                   |                          | `lambda = 0.1`                                                               | .80                      |     00h 29m    |
|        knn       | `k = 1`                                                                       |                          | `k = 13`                                                                     | .78                      |     125h 28m   |
|     LogiBoost    | `nIter = `                                                                    |                          | `nIter = 31`                                                                 | .75                      |     00h 21m    |
|      treebag     | `-`                                                                           |                          | `-`                                                                          | .79                      |     06h 07m    |
|        J48       | `C = `                                                                        |                          | `C = 0.25`                                                                   | .73                      |     01h 30m    |
|       rpart      | `cp = `                                                                       |                          | `cp = 0.0009827688`                                                          | .73                      |     00h 12m    |
|     svmLinear    | `C = `                                                                        |                          | `C = 1`                                                                      | .67                      |     15h 34m    |
|       JRip       | `NumOpt = `                                                                   |                          | `NumOpt = 5`                                                                 | .67                      |     06h 50m    |

### Timewise analysis plots
![xgbtree plot](./xgbTree_auc_plot.tiff)

***Fig. 7. Plot of the xgbTree classifier performance (AUC) for the timewise analysis.***

![gbm plot](./gbm_auc_plot.tiff)

***Fig. 7 (addition). Plot of the gbm classifier performance (AUC) for the timewise analysis.***
