library(inspre)
library(tidyverse)
tce <- read.table("/sc/arion/projects/psychgen/causal_networks_redux/tce_unannotated.csv",sep='\t',header=T,row.names=1)
tce_se <- read.table("/sc/arion/projects/psychgen/causal_networks_redux/tce_se_unannotated.csv",sep='\t',header=T,row.names=1
)

w <- make_weights(as.matrix(tce_se),max_med_ratio = 1.5)
tce[is.na(tce)] <- 0
param=list()
for(i in 1:298){
tmp<-as.data.frame(tce)
tmp[i,] <- 0
tmp[,i] <- 0
param[[i]] <- as.data.frame(inspre::fit_inspre_from_R(as.matrix(tmp),w,verbose=2,lambda=0.023,its=100,solve_its=5,DAG=T)$R_hat)
}
saveRDS(param,"jacknife_delete_one.RData")
