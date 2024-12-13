Args<-commandArgs(TRUE)
lam_min<-as.double(Args[1]) # exposure data - should be full list of snps
lam_max <- lam_min+0.01
# making some changes as per brielin's suggestion
library(inspre)
library(tidyverse)
tce <- read.table("/sc/arion/projects/psychgen/causal_networks_redux/tce_unannotated.csv",sep='\t',header=T,row.names=1)
tce_se <- read.table("/sc/arion/projects/psychgen/causal_networks_redux/tce_se_unannotated.csv",sep='\t',header=T,row.names=1)
tce_se <- as.matrix(tce_se)
diag(tce_se) <- NA
w <- make_weights(tce_se)
tce[is.na(tce)] <- 0
res<-inspre::fit_inspre_from_R(as.matrix(tce),w,verbose=2,lambda=seq(lam_min,lam_max,0.001),its=100,solve_its=10,rho=100,cv_folds=10,DAG=T,min_nz=0.001)
saveRDS(res,paste0('/sc/arion/projects/psychgen/causal_networks_redux/dce_res_',lam_min,'_to_',lam_max,'_results_weight_diag_changed_plus_dag.RData'))

