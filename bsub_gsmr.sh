#!/bin/bash
#BSUB -J munging
#BSUB -P acc_psychgen
#BSUB -q premium
#BSUB -n 2
#BSUB -R span[ptile=12]
#BSUB -W 1:00
#BSUB -M 12GB
#BSUB -o logs/%J.stdout
#BSUB -eo logs/%J.stderr
#BSUB -L /bin/bash
source ~/anaconda3/etc/profile.d/conda.sh
conda activate r_env
Rscript gsmr_forward_and_reverse_script.R one two 
