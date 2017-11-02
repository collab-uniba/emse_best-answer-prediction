# Dataset and R scripts for best-answers prediction in Technical Q&A sites

## Datasets
Data have been retrieved from the following technical Q&A sites:
* Modern platforms
  * [Stack Overflow (SO)](https://www.stackoverflow.com) 
  * [Yahoo! Answer (YA)](https://answers.yahoo.com/dir/index?sid=396545663&link=list) (category: _Programming & Design_)
  * [SAP Community Network (SCN)](https://www.sap.com/community.html) (topics: _Hana_, _Mobility_, _NetWeaver_, _Cloud_, _OLTP_, _Streaming_, _Analytic_, _PowerBuilder_, _Cross_, _3d_, _Frontend_, _ABAP_)
* Legacy platforms
  * [Dwolla](https://discuss.dwolla.com/c/api-support) (discontinued, read-only)
  * [Docusign](https://www.docusign.com) (discontinued, unavailable)
  
Datasets can be downloaded from the [datasets](https://github.com/collab-uniba/dataset_best-answers_emse/tree/master/datasets) subfolder.
  
### Formats
A description of dataset file formats is also available [here](https://github.com/collab-uniba/dataset_best-answers_emse/tree/master/datasets).

## R scripts
### Setup
To ensure proper execution, first run:
```
$ RScripts requirements.R
```
This will check for the presence and eventually install all required packages.

### Automated param tuning
To start the automated parameter tuning via `caret`, run the `run-tuning.sh` script as described below. 
```
$ run-tuning.sh models_file data_file
```
* The `models_file` param indicates a file containing (one per line) a list of models to be tuned. See the file `models/models.txt` for an example.
* The `data_file` param indicates a file containing the data to be used for the tuning stage.
* As output, a TXT file will be created under the `output/tuning/` subfolder for each tuned model, containing the best param configuration and execution times.

**Note** The tuning step is very time consuming and will take _several_ hours for each model; the more models in the input file, the longer the script will take to finish.

### Prediction experiment
Once the models have been tuned, you can execute the best-answer prediction experiment.
