#!/bin/bash

# read and trim params
dataset_file=$(echo $1 | xargs)
model_file=$(echo $2 | xargs)

if [[ -n "$dataset_file" && -n "$model_file" ]]; then
	printf " === Starting the model assessment for all classifiers with default param config (this may take a while...)\n"

	now=$(date +"%Y-%m-%d %H.%M")
	printf "\n\n:: Assessment starting at $now ::\n"
	time Rscript untuned-perf.R $dataset_file $model_file

	printf "\n\n:: Done ::\n"
else
	echo "Argument error: path/to/.. dataset and model files are required in order."
fi
