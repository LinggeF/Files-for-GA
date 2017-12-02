library(stringr)
library(reshape)
library(dplyr)
library(TFBSTools)
library(JASPAR2016)
#get pwmset from jsp2016
library(GenomicFeatures)
library(BSgenome.Hsapiens.UCSC.hg19)
library(TxDb.Hsapiens.UCSC.hg19.knownGene)
###PWMset building

#Define local database path
db <- file.path(system.file("extdata", package="JASPAR2016"),"JASPAR2016.sqlite")
opts <- list()
opts[["all"]] <- TRUE
siteList <- getMatrixSet(db, opts)
pwmMatx <- toPWM(siteList)
######################################################


###Genome sequence obtaining
txdb <- TxDb.Hsapiens.UCSC.hg19.knownGene
genome <- BSgenome.Hsapiens.UCSC.hg19
# the names are Ensembl gene IDs
up5000seqs <- extractUpstreamSeqs(genome, txdb, width=5000)
n<- length(up5000seqs)
######################################################

tfmatrix <- data.frame("absScore"=numeric(),"TF"=vector(),"gene"=vector())

for (i in 1:n){
  tmp <- up5000seqs[i]
  gene_name <- names(up5000seqs[i])
  cat("Number and gene name：",c(i,gene_name))
  tmp <- toString(tmp)
  tmp <-str_trim(chartr("N"," ",tmp))
  sitesetList <- searchSeq(pwmMatx, tmp, seqname="tmp", strand="*",min.score="80%")
  tmp_df <- as(sitesetList, "data.frame")
  sbtmp <- subset(tmp_df,select=c("absScore","TF"))
  grp_tmp <-sbtmp %>% group_by(TF)%>% summarise(Score = max(as.numeric(absScore)))
  grp_tmp$gene <- gene_name
  tfmatrix <- rbind(tfmatrix,grp_tmp)
}
  
reshape_tfm <- recast(data = tfmatrix, TF ~ gene, id.var = c("TF","gene"))
write.table(x = reshape_tfm, file = "TF_target_socringmatrix.txt",sep = "\t")


##
#tmp <- up5000seqs[1]
###string format processing
#tmp <- toString(tmp)
###cut"N",if upstreamseq less than 5000bp

#tmp <-str_trim(chartr("N"," ",tmp))



######################################################################################
####mapping
# sitesetList <- searchSeq(pwmMatx, tmp, seqname="tmp", strand="*",min.score="80%")
# tmp_df <- as(sitesetList, "data.frame")
# sbtmp <- subset(tmp_df,select=c("absScore","TF"))
# 
# ####grouping data by TF and select highest absscore for each TF
# grp_tmp <- tmp %>% group_by(TF)%>% summarise(Score = max(as.numeric(absScore)))
# grp_tmp$gene <- gene_name
# 
# #####################
# tmp <- up5000seqs[1]
# gene_name <- names(up5000seqs[1])
# tmp <- toString(tmp)
# tmp <-str_trim(chartr("N"," ",tmp))
# sitesetList <- searchSeq(pwmMatx, tmp, seqname="tmp", strand="*",min.score="80%")
# tmp_df <- as(sitesetList, "data.frame")
# sbtmp <- subset(tmp_df,select=c("absScore","TF"))
# grp_tmp <- sbtmp %>% group_by(TF)%>% summarise(max = max(as.numeric(absScore)))
# grp_tmp$gene <- gene_name






#


