import itertools
import subprocess
import glob
import argparse
print('processing....')

parser = argparse.ArgumentParser()


# add args and just return them

parser.add_argument('-i','--input', dest='infiles',type=str,required=True,help="where to glob-read list of files from")
parser.add_argument('-xs','--script', dest='script',type=str,required=True,help="path to script wrapper")
parser.add_argument('-o','--outdir', dest='outdir',type=str,required=True,help="where to write files")
parser.add_argument('-s','--real-script', dest='real_script',type=str,required=True,help="path to script wrapper")

args=parser.parse_args()

if 'txt' not in args.infiles[-4:]:

	files = glob.glob(f'{args.infiles}/*.sumstats.gz')
else:
	files = [i.split('\n')[0] for i in open(args.infiles).readlines()]
#file_keys=[i.split('/')[-1].split('.')[0] for i in files]

print('read files... beginning loop by generating combs.... hold tight')

pairs = itertools.combinations(files,2)
for pair in pairs:

	p1_name=pair[0].split('/')[-1].split('.')[0]
	p2_name=pair[1].split('/')[-1].split('.')[0]
		
	
	outname=f'{args.outdir}/{p1_name}_vs_{p2_name}_rg'
	
	subprocess.call(['bash',f'{args.script}',f'{pair[0]}',f'{pair[1]}',f'{outname}',f'{args.real_script}'])
print('submitted everything')


