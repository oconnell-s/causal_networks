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
bash looping_gsmr.sh /sc/arion/projects/psychgen/causal_networks_redux/data/combinations_file_keys_prob_entries.txt bsub_gsmr.sh 
