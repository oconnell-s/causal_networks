ilibrary(inspre)
library(testthat
library(tidyverse)
tce <- read.table("tce_unannotated.csv",sep='\t')
tce
head(tce)
tce <- read.table("tce_unannotated.csv",sep='\t',header=T)
head(tce)
rownames(tce)
tce <- read.table("tce_unannotated.csv",sep='\t',header=T,row.names=1)
head(tce)
tce_se <- read.table("tce_se_unannotated.csv",sep='\t',header=T,row.names=1)
tce_se
min(tce_se)
inspre::fit_inspre_from_X
inspre::fit_inspre_from_R
weights <- make_weights(tce_se)
weights <- make_weights(as.matrix(tce_se))
weights
max(weights)
min(weights)
inspre::fit_inspre_from_R(as.matrix(tce),weights)
inspre::fit_inspre_from_R(as.matrix(tce),weights,verbose=2)
inspre::fit_inspre_from_R(as.matrix(tce),weights,verbose=2,lambda=seq(0.01,0.4,10),its=10)
seq(0.01,0.4,10)
seq(from=0.01,to=0.4,by=0.01)
seq(from=0.01,to=0.4,by=0.03)
res<-inspre::fit_inspre_from_R(as.matrix(tce),weights,verbose=2,lambda=seq(0.01,0.4,0.03),its=10,solve_its=4)
res
res$gamma
res$L
res$R_hat
res$test_error
res$train_error
res<-inspre::fit_inspre_from_R(as.matrix(tce),weights,verbose=2,lambda=seq(0.01,0.4,0.03),its=10,solve_its=4,cv_folds=5)
res
res$gamma
res$D_hat
res<-inspre::fit_inspre_from_R(as.matrix(tce),weights,verbose=2,lambda=seq(0.3,0.6,0.03),its=10,solve_its=4,cv_folds=5)
res$D_hat
res$R_hat[11]
res$R_hat[10]
res$R_hat
res$R_hat[[11]]
res$R_hat[[1]]
dim(res$R_hat)
res$R_hat[,,11]
d<-res$R_hat[,,11]
max(d)
min(d)
for(i in 1:11){print(range(res$R_hat[,,i]))}
range(tce)
range(as.matrix(tce))
range(as.matrix(tce),na.rm=T)

# this is the invocation of inspre that yields somewhat reasonable outputs 
inspre::fit_inspre_from_R(as.matrix(tce),weights,verbose=2,lambda=seq(0.3,0.6,0.03),its=10,solve_its=4,cv_folds=5)
# this one seems to return mostly NAs despite fulfilling the graph stability criteria
res<-inspre::fit_inspre_from_R(as.matrix(tce),weights,verbose=2,lambda=seq(0.3,0.6,0.03),its=30,solve_its=7,cv_folds=5)
# the issue seems to be coming from the its paramater as opposed to the solve_its paramater 
# as evidenced by the output of this command 
res<-inspre::fit_inspre_from_R(as.matrix(tce),weights,verbose=2,lambda=seq(0.4,0.7,0.07),its=30,solve_its=5,cv_folds=5)

# here the solve its is similar and the only thing really changing is the its paramater. the loss values are all very high (over 3000 in the log likelihood space)
