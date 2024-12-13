#!/bin/bash

inp=$1
out=$2
sed -i 's/p/P/2' $inp 
outname=$out/$(basename ${inp%.*})
for i in {1..22};
do
plink --bfile $HRC_REF_EUR/HRC.r1-1.EGA.GRCh37.chr$i.impute.plink.EUR --clump $inp --clump-p1 1 --clump-p2 1 --clump-r2 0.001 --clump-kb 10000 --out $outname.chr$i &
done
wait
echo "done clumping... combining"
cat $outname.*.clumped | grep rs | awk '{print $3}' > $outname.top_snps.txt
echo "cleaning up..." 
rm $outname.*.clumped
rm $outname.chr*.log


