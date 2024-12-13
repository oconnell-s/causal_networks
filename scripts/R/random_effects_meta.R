install.packages("metafor")
res<-metafor::rma(yi=c(0.0287,0.0538),sei = c(0.116,0.214),measure = "OR",
         slab=c("Oslo","Galway"),)
grid::grid.text("Forest plot of direct beta causal score effect on BD", .5, .75, gp=grid::gpar(cex=1.4))

summary(res)
