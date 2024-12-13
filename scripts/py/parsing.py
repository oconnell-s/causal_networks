import pandas as pd
import argparse



### argparse chunk goes here 

parser = argparse.ArgumentParser()


# add args and just return them

parser.add_argument('-f','--file',dest='input',type=str,required=True,help="Path to input file")
parser.add_argument('-oa','--allele',dest='allele',type=str,required=True,help="where to write allele files")
parser.add_argument('-o','--outdir',dest='outdir',type=str,required=True,help="where to write MR-ready files")



###

args=parser.parse_args()


with open('/sc/arion/projects/psychgen/causal_networks_redux/data/clumped/files_gt_10_clumped_instr.txt','r') as w:
    f = [i.split('\n')[0] for i in w.readlines()]
snp_name = args.input.split('/')[-1].split('.')[0]
assert f'{snp_name}.top_snps.txt' in f, print('file not in list... aborting')

d = pd.read_csv(args.input,sep='\t')
snps = [i.split('\n')[0] for i in open(f'/sc/arion/projects/psychgen/causal_networks_redux/data/clumped/{snp_name}.top_snps.txt','r').readlines()]
d.index = d.SNP
snp_df = d.loc[snps][['SNP','A2','A1','b','se','P','N']]
with open(f'{args.allele}/{snp_name}.allele','w') as w:
    for item in [' '.join(list(i)) for i in snp_df[['SNP','A1']].values]:
        w.write(f'{item}\n')
snp_df.to_csv(f'{args.outdir}/{snp_name}.gsmr_input.txt',index=False)
print('done')
