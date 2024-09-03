#!/bin/bash


	

list_of_files=$1
# this is actually a curl script 
script=$2
# here, small adjustment to rerun just BD pairs
cat $list_of_files | while read line;
do
a=($line)
one=${a[0]}
two=${a[1]}
sed -e "s#one#$(echo $one)#g" -e "s#two#$(echo $two)#g" $script | bsub
done




