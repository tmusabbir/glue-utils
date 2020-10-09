#!/bin/bash

# Delete Glue resources (crawlers, jobs, triggers and workflows) based on a Blueprint name

DRY_RUN=false

while getopts ":b:d" opt; do
  case $opt in
    d)
      DRY_RUN=true
      ;;
    b)
      BLUEPRINT_NAME=$OPTARG
      echo BLUEPRINT_NAME="$BLUEPRINT_NAME"
      ;;
    :)
      echo "MISSING ARGUMENT for option -- ${OPTARG}" >&2
      exit 1
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      ;;
  esac
done

echo DRY_RUN=$DRY_RUN

glueCrawlerName=$(aws glue get-crawlers | jq -r '.Crawlers[] | select(.Name | startswith('\""$BLUEPRINT_NAME"\"')) | .Name')
if [ -n "$glueCrawlerName" ]; then
  echo "Executing: aws glue delete-crawler --name ""$glueCrawlerName"
  if [ "$DRY_RUN" = false ]; then
    aws glue delete-crawler --name "$glueCrawlerName"
  fi
fi

glueJobs=$(aws glue get-jobs | jq -r '.Jobs[] | select(.Name | startswith('\""$BLUEPRINT_NAME"\"')) | .Name')
if [ -n "$glueJobs" ]; then
  for jobName in $glueJobs; do
    echo "Executing: aws glue delete-job --job-name ""$jobName"
    if [ "$DRY_RUN" = false ]; then
      aws glue delete-job --job-name "$jobName"
    fi
  done
fi

glueTriggers=$(aws glue get-triggers | jq -r '.Triggers[] | select(.Name | startswith('\""$BLUEPRINT_NAME"\"')) |
.Name')
if [ -n "$glueTriggers" ]; then
  for triggerName in $glueTriggers; do
    echo "Executing: aws glue delete-trigger --name ""$triggerName"
    if [ "$DRY_RUN" = false ]; then
      aws glue delete-trigger --name "$triggerName"
    fi
  done
fi

glueWorkflowName=$(aws glue list-workflows | jq -r '.Workflows[] | select(. | startswith
('\""$BLUEPRINT_NAME"\"'))')
if [ -n "$glueWorkflowName" ]; then
  echo "Executing: aws glue delete-workflow --name ""$glueWorkflowName"
  if [ "$DRY_RUN" = false ]; then
    aws glue delete-workflow --name "$glueWorkflowName"
  fi
fi
