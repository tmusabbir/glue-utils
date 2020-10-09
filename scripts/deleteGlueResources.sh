#!/bin/bash

glueCrawlers=`aws glue get-crawlers | jq -r .Crawlers[].Name`
glueCrawlers=${glueCrawlers// /$'\n'}
for crawlerName in $glueCrawlers; do
  echo "Executing: aws glue delete-crawler --name "$crawlerName
  res=`aws glue delete-crawler --name $crawlerName`
done

glueJobs=`aws glue get-jobs | jq -r .Jobs[].Name`
glueJobs=${glueJobs// /$'\n'}
for jobName in $glueJobs; do
  echo "Executing: aws glue delete-job --job-name "$jobName
  res=`aws glue delete-job --job-name $jobName`
done

glueTriggers=`aws glue get-triggers | jq -r .Triggers[].Name`
glueTriggers=${glueTriggers// /$'\n'}
for triggerName in $glueTriggers; do
  echo "Executing: aws glue delete-trigger --name "$triggerName
  res=`aws glue delete-trigger --name $triggerName`
done

glueWorkflows=`aws glue list-workflows | jq -r .Workflows[]`
glueWorkflows=${glueWorkflows// /$'\n'}
for wfName in $glueWorkflows; do
  echo "Executing: aws glue delete-workflow --name "$wfName
  res=`aws glue delete-workflow --name $wfName`
done