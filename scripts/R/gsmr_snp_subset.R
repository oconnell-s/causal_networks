library(tidyverse)
library(gsmr2)
Args<-commandArgs(TRUE)
stats<-read.table(Args[1])
work_dir <- '/sc/arion/projects/psychgen/causal_networks_redux/'
exp_key <- strsplit(tail(strsplit(Args[1],split='/')[[1]],n=1),split='_')[[1]][1]
offs<-scan("/sc/arion/projects/psychgen/causal_networks_redux/confounder_screening/clump_ready/truclump/confounder_snps_all_update.txt",what="")
snp_coeff_id = scan(paste0(work_dir,"/data/allele/",exp_key,"_preclump.ld_mat.xmat.gz"), what="", nlines=1)
snp_coeff = read.table(paste0(work_dir,"/data/allele/",exp_key,"_preclump.ld_mat.xmat.gz"), header=F, skip=2)
stats <- stats %>% filter(! SNP %in% offs)
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
        { gsmr(bzx=stats$b, bzx_se=stats$se, bzx_pval=stats$P, bzy=stats$b_y, bzy_se=stats$se_y, bzy_pval=stats$p_y, ldrho=ldrho, n_ref=16886, heidi_outlier_flag=T, gwas_thresh=1, multi_snps_heidi_thresh=0.01, nsnps_thresh=5, ld_r2_thresh=0.05, ld_fdr_thresh=0.05, gsmr2_beta=1,snpid=colnames(ldrho))
        #when it throws an error, the following block catches the error
        }, error = function(msg){
            return(0)
        })



if(typeof(gsmr_results)!='double'){
res <- data.frame(bxy=gsmr_results$bxy,se=gsmr_results$bxy_se,p=gsmr_results$bxy_pval)
} else {
res <- data.frame(bxy=NA,se=NA,p=NA)
}


write.table(res,paste0(Args[1],'_results.txt'))

print("ran gsmr in both directions successfully")
