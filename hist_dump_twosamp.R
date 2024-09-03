brary(TwoSampleMR)
available_outcomes()
bmi_exp_dat <- extract_instruments(outcomes = 'ieu-a-2')
 options(ieugwasr_api = 'gwas-api.mrcieu.ac.uk/')
bmi_exp_dat <- extract_instruments(outcomes = 'ieu-a-2')
chd_out_dat <- extract_outcome_data(snps = bmi_exp_dat$SNP, outcomes = 'ieu-a-7')
dat <- harmonise_data(bmi_exp_dat, chd_out_dat)
dat
typeof(dat)
dat[[1]]
dat[[2]]
dat[[3]]
dat[[4]]
dat[[5]]
dat[[6]]
dat[[7]]
dat[[8]]
dat[[9]]
dat[[10]]
read_exposure_data
d
d <- read.table("../BD_vs_1436_plotting_table.txt")
D
d
library(tidyverse) 
subset(d,select=c(SNP,A1,A2,b,se))
subset(d,select=c(SNP,b,se,A1,A2))
exp_data <- subset(d,select=c(SNP,b,se,A1,A2))
out_data <- subset(d,select=c(SNP,b_y,se_y,A1_y,A2_y))
read_exposure_data
exposure_dat <- format_data(exp_data,type='exposure',effect_allele_col='A1',beta_col='b',se_col='se',other_allele_col='A2',snp_col='SNP')
outcome_dat <- format_data(exp_data,type='outcome',effect_allele_col='A1_y',beta_col='b_y',se_col='se_y',other_allele_col='A2_y',snp_col='SNP')
outcome_dat <- format_data(out_data,type='outcome',effect_allele_col='A1_y',beta_col='b_y',se_col='se_y',other_allele_col='A2_y',snp_col='SNP')
dat <- harmonise_data(exposure_dat,outcome_dat,action=2)
dat <- harmonise_data(exposure_dat,outcome_dat,action=1)
mr(dat)
res<-mr(dat)
mr_leaveoneout(dat)
dat <- harmonise_data(exposure_dat,outcome_dat,action=2)
mr_leaveoneout(dat)
sys.call("bjobs")
dat <- harmonise_data(exposure_dat,outcome_dat,action=1)
enrichment(dat)

mr_wrapper(dat)
