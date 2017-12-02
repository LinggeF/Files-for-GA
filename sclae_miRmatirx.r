
###build matrix
a <- (subset(miR_table,select = -miRNA))
###scale matrix to (0,1) by divide it by max(matrix)
b<- apply(a , 2, FUN = function(X) (X)/13)


miRNA <- as.vector(miR_table$miRNA)

c <- cbind(miRNA = miRNA,b)

write.table(x = c, file = "scaled_mmir-matrix1(NA_0).txt",sep = "\t")
