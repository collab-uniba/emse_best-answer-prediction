
## Automated parameter tuning

***Table 9 (complete). Default and optimal parameter configuration with AUC performance and overall tuning runtime (in hours) for the 26 models (`?` indicates a value not explicitly mentioned in documentation, but deduced from the implementation; for parameters with no default values, we used the first valid value).***

| Prediction model |                        Default parameter configuration                        | Default AUC  performance |                        Optimal parameter configuration                       | Optimal AUC  performance | Tuning runtime |
|:----------------:|:-----------------------------------------------------------------------------:|:------------------------:|:----------------------------------------------------------------------------:|:------------------------:|:--------------:|
|      xgbTree     | `nrounds = 100,  max_depth = 1,  eta = 0.3`                                   |            .81           | `nrounds = 200,  max_depth = 4,  eta = 0.1`                                  |            .94           |     06h 47m    |
|      pcaNNet     | `size = 1, decay = 0`                                                         |            .50           | `size = 7, decay = 0.1`                                                      |            .93           |     02h 20m    |
|       earth      | `nprune = NULL, degree = 1`                                                   |            .50           | `nprune = 15, degree = 1`                                                    |            .93           |     03h 53m    |
|        gbm       | `n.trees = 100, interaction.depth = 1,  shrinkage = 0.1, n.minobsinnode = 10` |            .79           | `n.trees = 250, interaction.depth = 3, shrinkage = 0.1, n.minobsinnode = 10` |            .94           |     08h 44m    |
|     gamboost     | `mstop = 100, prune = no?`                                                    |            .78           | `mstop = 250, prune = no`                                                    |            .88           |     02h 06m    |
|       nnet       | `size = <no default>, decay = 0`                                              |            .50           | `size = 9, decay = 0.1`                                                      |            .83           |     25h 10m    |
|        LMT       | `iter = <no default>?`                                                        |            .76           | `iter = 81`                                                                  |            .84           |     75h 54m    |
|      avNNet      | `bag = FALSE, size = <no default>?, decay = <no default>?`                    |            .50           | `bag = FALSE, size = 9, decay = 0.1`                                         |            .83           |     11h 15m    |
|       C5.0       | `trials = 1, model = {trees, rules}, winnow = FALSE`                          |            .39           | `trials = 40, model = rules, winnow = FALSE `                                |            .83           |     07h 05m    |
|     AdaBoost     | `mfinal = 100, maxdepth = #classes, coeflearn = Breiman`                      |            .80           | `mfinal = 250, maxdepth = 3, coeflearn = Freund`                             |            .82           |    114h 48m    |
|     multinom     | `decay = 0`                                                                   |            .74           | `decay = 0`                                                                  |            .84           |     01h 05m    |
|        rf        | `mtry = sqrt(#variables in dataframe)`                                        |            .74           | `mtry = 6`                                                                   |            .84           |     73h 24m    |
|        lda       | `-`                                                                           |            .55           | `-`                                                                          |            .84           |     00h 06m    |
|  mlpWeightDecay  | `decay = 0?, size = 5`                                                        |            .50           | `decay = 1e-04, size = 9`                                                    |            .84           |     85h 18m    |
|        glm       | `-`                                                                           |            .74           | `-`                                                                          |            .81           |     00h 08m    |
|        nb        | `fL = 0, usekernel = FALSE, adjust = <no default>`                            |            .66           | `fL = 0, usekernel = FALSE, adjust = 1`                                      |            .81           |     00h 53m    |
|        mlp       | `size = 5`                                                                    |            .50           | `size = 9`                                                                   |            .80           |     44h 12m    |
|        fda       | `degree = 1?, nprune = 2?`                                                    |            .71           | `degree = 1, nprune = 15`                                                    |            .81           |     01h 34m    |
|        pda       | `lambda = 1`                                                                  |            .58           | `lambda = 0.1`                                                               |            .80           |     00h 29m    |
|        knn       | `k = 1`                                                                       |            .45           | `k = 13`                                                                     |            .78           |     125h 28m   |
|    LogitBoost    | `nIter = #column of dataframe`                                                |            .77           | `nIter = 31`                                                                 |            .75           |     00h 21m    |
|      treebag     | `-`                                                                           |            .72           | `-`                                                                          |            .79           |     06h 07m    |
|        J48       | `C = 0.25`                                                                    |            .47           | `C = 0.25`                                                                   |            .73           |     01h 30m    |
|       rpart      | `cp = 0`                                                                      |            .65           | `cp = 0.0009827688`                                                          |            .73           |     00h 12m    |
|     svmLinear    | `C = 0.1?`                                                                    |            .62           | `C = 1`                                                                      |            .67           |     15h 34m    |
|       JRip       | `NumOpt = 2`                                                                  |            .55           | `NumOpt = 5`                                                                 |            .67           |     06h 50m    |


## Timewise analysis 
![xgbtree plot](../output/timewise/plots/xgbTree/xgbTree_auc_plot.tiff)

***Fig. 7. Plot of the xgbTree classifier performance (AUC) for the timewise analysis.***

![gbm plot](../output/timewise/plots/gbm/gbm_auc_plot.tiff)

***Fig. 7 (addition). Plot of the gbm classifier performance (AUC) for the timewise analysis.***
