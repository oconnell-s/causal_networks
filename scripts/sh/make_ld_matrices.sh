#!/bin/bash
ml gcta/1.94.1
inp=$1
out=${inp%%.*}
gcta64 --mbfile /sc/arion/projects/psychgen/causal_networks_redux/scratch/gsmr_ref_data.txt --extract $inp --update-ref-allele $inp --recode --out $out.ld_mat
