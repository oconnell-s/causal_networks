#!/bin/bash
#BSUB -J submission
#BSUB -P acc_psychgen
#BSUB -q long
#BSUB -n 1
#BSUB -R span[ptile=12]
#BSUB -W 60:00
#BSUB -o logs/%J.stdout
#BSUB -eo logs/%J.stderr
#BSUB -L /bin/bash
cd /sc/arion/projects/psychgen/causal_networks_redux/
while [[bjobs | wc -l -gt 200]];
do
mv *.txt results
sleep 60
done
