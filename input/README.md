## Dataset input files
The dataset for each Q&A site is available in CSV file format, using `;` as separator. The file columns match the features described in Table 1 below.

***Table 1. Summary of the overall 22 features in our model, arranged by category.***

| *Category* | *Feature*                             | *Also ranked?* |
|:----------:|:--------------------------------------|:--------------:|
| Linguistic | Length (in characters)                |      Yes       |
|            | Word count                            |      Yes       |
|            | No. of sentences                      |      Yes       |
|            | Longest sentence (in characters)      |      Yes       |
|            | Avg words per sentence                |      Yes       |
|            | Avg chars per word                    |      Yes       |
|            | Contains hyperlinks (boolean)         |       -        |
| Vocabulary | LLn                                   |      Yes       |
|            | F-K                                   |      Yes       |
|    Meta    | Age (hh:mm:ss)                        |      Yes       |
|            | Rating score (upvotes – downvotes)    |      Yes       |
|   Thread   | Answer count                          |       -        |

**Notes**
* Time-related features come in different formats. Check the [dump file formats page](https://github.com/collab-uniba/dataset_best-answers_emse/tree/master/dumps) for details before parsing.
* CSV files may contain more columns than those reported in Table 1. This is because some extra features (e.g., tags, number of answer views) were extracted but not eventually used  because not commonly available on all datasets.
