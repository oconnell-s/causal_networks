library(tidyverse)
library(TwoSampleMR)
Args<-commandArgs(TRUE)
d<-read.table(Args[1])
outdir<-Args[2]
oname <- strsplit(strsplit(Args[1],split='/')[[1]][length(strsplit(Args[1],split='/')[[1]])],'.txt')[[1]][1]
oname <- paste0(outdir,'/',oname)
exp_data <- subset(d,select=c(SNP,b,se,A1,A2))
out_data <- subset(d,select=c(SNP,b_y,se_y,A1_y,A2_y))
exposure_dat <- format_data(exp_data,type='exposure',effect_allele_col='A1',beta_col='b',se_col='se',other_allele_col='A2',snp_col='SNP')
outcome_dat <- format_data(out_data,type='outcome',effect_allele_col='A1_y',beta_col='b_y',se_col='se_y',other_allele_col='A2_y',snp_col='SNP')
dat <- harmonise_data(exposure_dat,outcome_dat,action=1)
res <- mr(dat)
lo_res <- mr_leaveoneout(dat)
write.csv(as.data.frame(res),paste0(oname,".twosamplemr.txt"))
write.csv(as.data.frame(lo_res),paste0(oname,".loo_twosamplemr.txt"))

