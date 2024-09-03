Args<-commandArgs(TRUE)
lam_min<-as.double(Args[1]) # exposure data - should be full list of snps
lam_max <- lam_min+0.01
# making some changes as per brielin's suggestion
library(inspre)
library(tidyverse)
tce <- read.table("/sc/arion/projects/psychgen/causal_networks_redux/tce_unannotated.csv",sep='\t',header=T,row.names=1)
tce_se <- read.table("/sc/arion/projects/psychgen/causal_networks_redux/tce_se_unannotated.csv",sep='\t',header=T,row.names=1)

## try different weights function (just allowing no ratio option, or normalization for mean)

make_weights_primal <- function(SE) {
  weights <- 1 / SE^2
  weights[is.na(SE)] <- 0
  infs <- is.infinite(weights)
  max_weight <- max(weights[!infs])
  weights[infs] <- max_weight
  return(weights)
}

w <- make_weights_primal(as.matrix(tce_se))
tce[is.na(tce)] <- 0
res<-inspre::fit_inspre_from_R(as.matrix(tce),w,verbose=2,lambda=seq(lam_min,lam_max,0.001),its=100,solve_its=10,rho=100,cv_folds=10,DAG=T,min_nz=0.0005)
saveRDS(res,paste0('/sc/arion/projects/psychgen/causal_networks_redux/dce_res_',lam_min,'_to_',lam_max,'_results_update_smaller_nz_and_weights.RData'))

