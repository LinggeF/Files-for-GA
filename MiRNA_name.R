temp<- strsplit(temp_mir,"_")
mir_name <- vector()
for(i in 1:length(temp_mir)){
  mir_name[i] <- temp[[i]][2] 
}
################################
temp<- strsplit(temp_mir,"-")
mir_name1 <- vector()
for (i in 1:length(temp_mir)){
  mir_name1[i] <- gsub(" ","",chartr(",","-",toString(temp[[i]][1:3])))
}
temp<- strsplit(mir_name1,"_")
for(i in 1:length(temp_mir)){
  mir_name1[i] <- temp[[i]][1] 
}


tb<-read.table("miRNA_name.txt",head = F)
tb <- unique(tb)
write(as.vector(tb$V1),"miRNA_name_unique.txt",sep = " ")