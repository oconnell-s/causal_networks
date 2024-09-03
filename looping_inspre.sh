#!/bin/bash
# this is actually a curl script 
script=$1
job=$2
# here, small adjustment to rerun just BD pairs


for min in $(seq 0.001 0.01 1);
do
sed -e "s#min#$(echo $min)#g" -e "s#job#$(echo $job)#g" $script | bsub
done




