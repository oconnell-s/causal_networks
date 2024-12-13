import argparse 
import pandas as pd
import json

#### argparse chunk will go here 
parser = argparse.ArgumentParser()
parser.add_argument('-f','--file',dest='file',type=str,required=True,help="Path to input file")
parser.add_argument('-o','--outdir',dest='outdir',type=str,required=True,help="Path to store files")
parser.add_argument('-n','--n-col',dest='ncol',type=str,default='N(disc)',help="n col (assuming discovery)")
parser.add_argument('-p','--pval',dest='pthresh',default=5e-8,type=float,required=False,help="pval thresh")
args=parser.parse_args()
####


d = pd.read_csv(args.file,compression='gzip',sep=' ',low_memory=False)
v_d=json.load(open('/sc/arion/projects/psychgen/causal_networks_redux/data/variant_af_info_lookup.txt')) # get eaf and info values per variant 
d['p'] = 10**-d['pval(-log10)'] # convert info 
d=d.drop(['pval(-log10)'],axis=1) # get rid of log10 column 
d[['EAF','INFO']] = [v_d[i] for i in d['rsid']]
d=d.rename(columns={"EAF":"frq","beta":"b","rsid":'SNP','a2':'A1','a1':'A2'}) # this is the other way around because of the coding of the UKB alleles (where a2 is the effect allele)
n_lookup = pd.read_csv('/sc/arion/projects/psychgen/causal_networks_redux/analysis/supplementary_materials_w_sig_snps.xlsx',sep='\t')
d['N'] = [n_lookup[n_lookup['Pheno.1']==int(args.file.split('/')[-1].split('.')[0])][args.ncol].values[0]] * d.shape[0]
autosome_stats = d[d['chr']!='0X'] # get rid of sex chromosome 
autosome_stats.chr = [int(i) for i in autosome_stats.chr] # column type that plink likes 
outname = args.outdir + '/' + args.file.split('/')[-1].split('.')[0] + '_preclump.assoc'
autosome_stats[autosome_stats.p<=args.pthresh].to_csv(outname,index=False,sep='\t')
