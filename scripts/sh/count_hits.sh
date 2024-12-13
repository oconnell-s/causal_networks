#!/bin/bash
#BSUB -J counting
#BSUB -P acc_psychgen
#BSUB -q premium
#BSUB -n 1
#BSUB -M 10GB
#BSUB -R span[ptile=12]
#BSUB -W 30
#BSUB -o logs/%J.stdout
#BSUB -eo logs/%J.stderr
#BSUB -L /bin/bash
ml dataark

number=$(zcat input | LC_ALL=C awk '{if ($8 > 7.301) print $8}' | wc -l)

echo "input $number" >> outfile

 
