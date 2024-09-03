#!/bin/bash
#BSUB -J munging
#BSUB -P acc_psychgen
#BSUB -q premium
#BSUB -n 3
#BSUB -R span[ptile=12]
#BSUB -W 2:15
#BSUB -M 8GB
#BSUB -o inspre_new_logs/%J.stdout
#BSUB -eo inspre_new_logs/%J.stderr
#BSUB -L /bin/bash
source ~/anaconda3/etc/profile.d/conda.sh
conda activate r_env
Rscript job min 
