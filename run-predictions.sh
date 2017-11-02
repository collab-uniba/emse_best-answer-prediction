#!/bin/bash

# read and trim params
training_file=$(echo $1 | xargs)
model_file=$(echo $2 | xargs)

if [[ -n "$training_file" && -n "$model_file" ]]; then
    printf " === Starting the model assessment for top-ranked classifiers (this may take a while...)\n"

    now=$(date +"%Y-%m-%d %H.%M")
    printf "\n\n:: Assessment on testset docusign -- starting at $now ::\n"
    time Rscript test.R $training_file docusign $model_file

    now=$(date +"%Y-%m-%d %H.%M")
    printf "\n\n:: Assessment on testset dwolla -- starting at $now ::\n"
    time Rscript test.R $training_file dwolla $model_file

    now=$(date +"%Y-%m-%d %H.%M")
    printf "\n\n:: Assessment on testset yahoo -- starting at $now ::\n"
    time Rscript test.R $training_file yahoo $model_file

    now=$(date +"%Y-%m-%d %H.%M")
    printf "\n\n:: Assessment on testset scn -- starting at $now ::\n"
    time Rscript test.R $training_file scn $model_file
    
    printf "\n\n:: Done ::\n"
else
    echo "Argument error: path/to/.. training dataset and model files are required in order."
fi
