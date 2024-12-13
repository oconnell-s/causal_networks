Args<-commandArgs(TRUE)
exp_key<-Args[1] # exposure data - should be full list of snps
out_key<-Args[2]
workflow_gsmr_plot <- function(exp_key,out_key){
work_dir<-'/sc/arion/projects/psychgen/causal_networks_redux/'
brain_dir<-'/sc/arion/projects/data-ark/Public_Unrestricted/GWAS_SumStats/UKB_BrainImaging_GWAS/repro/'
# the chunk below is due to editing and reformatting required for both BD and the 1332 phenotype 
if(grepl("BD|1332",out_key)){
outcome_file <- paste0(work_dir,'data/',out_key,".txt.gz")
} else {
	
outcome_file <- paste0(brain_dir,out_key,".txt.gz")

}


library(tidyverse)
library(magrittr)
library(gsmr2)
exp <- read_csv(paste0(work_dir,"/data/indexed_gsmr/",exp_key,"_preclump.gsmr_input.txt"))
# key will be the only index, and then can run gsmr in both directions in the same script (this runs pretty fast as is)
# can spin this up tomorrow 
# can even source the functions from a different script 
stats <- read_delim(outcome_file,delim=' ') %>% filter(rsid %in% exp$SNP) %>% mutate(p=10**-`pval(-log10)`) %>% distinct(rsid,.keep_all=T) %>% rename(SNP=rsid,b_y=beta,se_y=se,p_y=p,A1_y=a2,A2_y=a1) %>% full_join(exp,by='SNP')
# recode allele flip if necessary 
stats$b_y <- ifelse(stats$A1_y != stats$A1, stats$b_y * -1, stats$b_y)

snp_coeff_id = scan(paste0(work_dir,"/data/allele/",exp_key,"_preclump.ld_mat.xmat.gz"), what="", nlines=1)
snp_coeff = read.table(paste0(work_dir,"/data/allele/",exp_key,"_preclump.ld_mat.xmat.gz"), header=F, skip=2)

# Match the SNP genotype data with the summary data
snp_id = Reduce(intersect, list(stats$SNP, snp_coeff_id))
stats = stats[match(snp_id, stats$SNP),]
snp_order = match(snp_id, snp_coeff_id)
snp_coeff_id = snp_coeff_id[snp_order]
snp_coeff = snp_coeff[, snp_order]

# Calculate the LD correlation matrix
ldrho = cor(snp_coeff)
# sometimes SNPs may not have any variation in the HRC panel (primarily for UKB phenotypes) so we need a block to deal with that when it happens so that gsmr can return 
# something. when there are na's in the correlation matrix gsmr does not complete 
colnames(ldrho) = rownames(ldrho) = snp_coeff_id
lddf <- as.data.frame(ldrho)
tmpdf <- lddf[ , colSums(is.na(lddf))<=1] 
ldrho <- tmpdf[rowSums(is.na(tmpdf))<=1,]
bad_snps <- rownames(tmpdf[rowSums(is.na(tmpdf))>=1,])
stats <- stats %>% filter(!(SNP %in% bad_snps))




# ensure match

# we have a try catch block for cases where SNPs may be pruned or lost 

gsmr_results <- tryCatch(
        #this is the chunk of code we want to run
        { gsmr(bzx=stats$b, bzx_se=stats$se, bzx_pval=stats$P, bzy=stats$b_y, bzy_se=stats$se_y, bzy_pval=stats$p_y, ldrho=ldrho, n_ref=16886, heidi_outlier_flag=T, gwas_thresh=1, multi_snps_heidi_thresh=0.01, nsnps_thresh=10, ld_r2_thresh=0.05, ld_fdr_thresh=0.05, gsmr2_beta=1,snpid=colnames(ldrho))
        #when it throws an error, the following block catches the error
        }, error = function(msg){
            return(0)
        })



if(typeof(gsmr_results)!='double'){
res <- data.frame(bxy=gsmr_results$bxy,se=gsmr_results$bxy_se,p=gsmr_results$bxy_pval)
} else {
res <- data.frame(bxy=NA,se=NA,p=NA)
}


# plot chunk
bzx=stats$b 
bzx_se=stats$se
bzy=stats$b_y
bzy_se=stats$se_y
filtered_index=gsmr_results$used_index
effect_col = colors()[75]
vals = c(bzx[filtered_index]-bzx_se[filtered_index], bzx[filtered_index]+bzx_se[filtered_index])
xmin = min(vals); xmax = max(vals)
vals = c(bzy[filtered_index]-bzy_se[filtered_index], bzy[filtered_index]+bzy_se[filtered_index])
ymin = min(vals); ymax = max(vals)
jpeg(file=paste0(exp_key,'_vs_',out_key,".jpeg"))
par(mar=c(5,5,4,2))
plot(bzx[filtered_index], bzy[filtered_index], pch=20, cex=0.8, bty="n", cex.axis=1.1, cex.lab=1.2,
        col=effect_col, xlim=c(xmin, xmax), ylim=c(ymin, ymax),
        xlab=expression(IDP~exp_key~(italic(b[zx]))),
        ylab=expression(out_key~(italic(b[zy]))))
abline(0, gsmr_results$bxy, lwd=1.5, lty=2, col="dim grey")

nsnps = length(bzx[filtered_index])
for( i in 1:nsnps ) {
    # x axis
    xstart = bzx[filtered_index[i]] - bzx_se[filtered_index[i]]; xend = bzx[filtered_index[i]] + bzx_se[filtered_index[i]]
    ystart = bzy[filtered_index[i]]; yend = bzy[filtered_index[i]]
    segments(xstart, ystart, xend, yend, lwd=1.5, col=effect_col)
    # y axis
    xstart = bzx[filtered_index[i]]; xend = bzx[filtered_index[i]] 
    ystart = bzy[filtered_index[i]] - bzy_se[filtered_index[i]]; yend = bzy[filtered_index[i]] + bzy_se[filtered_index[i]]
    segments(xstart, ystart, xend, yend, lwd=1.5, col=effect_col)
}
#write.table(res,paste0(work_dir,'/',exp_key,'_vs_',out_key,'_results.txt'))
dev.off()
write.table(stats[filtered_index,],paste0(work_dir,'/',exp_key,'_vs_',out_key,'_plotting_table.txt'))
}

workflow_gsmr_plot(exp_key=exp_key,out_key=out_key)
print("ran gsmr and saved plot")
