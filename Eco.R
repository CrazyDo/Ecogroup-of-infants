## Eco-group identification
## 2022.1.8
## Menglei Shuai

library(SpiecEasi)
library(FactoMineR)
library(factoextra)
library(pheatmap)

eco <- function(x, f_taxa_col, l_taxa_col, method=c("RA","SparCC")) {
  if (dir.exists("Data_sets/")==FALSE) {
    dir.create("Data_sets/")
  }
  if (dir.exists("Covariance_matrix/")==FALSE) {
    dir.create("Covariance_matrix/")
  }
  
  allfile <- dir("Data_sets/")
  targ <- grep("*.txt",allfile)
  file.remove(paste("Data_sets/",allfile[targ],sep = ''))
  
  allfile <- dir("Covariance_matrix/")
  targ <- grep("*.txt",allfile)
  file.remove(paste("Covariance_matrix/",allfile[targ],sep = ''))
  
  for (i in 1:length(table(x$tp))) {
    if (method=="RA") {
      dt <- x[which(x$tp==names(table(x$tp)[i])),f_taxa_col:l_taxa_col]  # use relative abundance
    }else if (method=="SparCC") {
      dt <- x[which(x$tp==names(table(x$tp)[i])),f_taxa_col:l_taxa_col]  # use counts
    }
    
    write.table(dt,paste("Data_sets/data_",i,".txt",sep = ""),row.names = TRUE, col.names = TRUE, quote = TRUE, sep = "\t")
  }
  print("Datasets have been prepared!")
  
  file_names <- dir("Data_sets", pattern = glob2rx("data_*.txt")) 
  for (f in file_names) {
    rdata <- read.delim(paste("Data_sets/",f,sep = ""),header = TRUE,row.names = 1, sep = "\t")
    
    if (method=="RA") {
      cor1 <- cov(as.matrix(rdata),method = "pearson")
    }else if (method=="SparCC") {
      sparcc.amgut <- sparcc(rdata, iter = 100, inner_iter = 10, th=0.1)
      cor1 <- sparcc.amgut$Cov
    }
    
    colnames(cor1) <- colnames(rdata)
    rownames(cor1) <- colnames(rdata)
    write.table(cor1, paste("Covariance_matrix/",f,sep = ""),row.names = TRUE, col.names = TRUE, quote = FALSE, sep = "\t")
  }
  print("Covariances have been evaluated!")
  
  file_names <- dir("Covariance_matrix", pattern = glob2rx("data_*.txt")) 
  for (f in file_names) {
    rdata <- read.delim(paste("Covariance_matrix/",f,sep = ""),header = TRUE,row.names = 1, sep = "\t")
    cor1 <- as.matrix(rdata)
    a <- quantile(cor1, probs = c(0.1,0.9))
    cor1[cor1>a[[1]] & cor1<a[[2]]] <- 0
    cor1[cor1<=a[[1]]] <- 1
    cor1[cor1>=a[[2]]] <- 1
    write.table(cor1, paste("Covariance_matrix/",f,sep = ""),row.names = TRUE, col.names = TRUE, quote = FALSE, sep = "\t")
  }
  print("Covariances matrix have been transformed!")
  
  file_names <- dir("Covariance_matrix", pattern = glob2rx("data_*.txt")) 
  i <- 1
  re <- list()
  for (f in file_names) {
    rdata <- read.delim(paste("Covariance_matrix/",f,sep = ""),header = TRUE,row.names = 1, sep = "\t")
    re[[i]] <- rdata
    i=i+1
  }
  
  for (j in 1:length(file_names)) {
    if (j==1) {
      re1 <-  re[[1]]
    }else{
    re1 <- re1+re[[j]]}
  }
  re1 <- re1/length(file_names)
  re1 <- as.matrix(re1)
  
  eco.pca <- PCA(re1, graph = FALSE,ncp = 5)
  var <- get_pca_var(eco.pca)
  cc <- as.data.frame(var$contrib) ##查看各变量对于各主成分的贡献
  cc1 <- cc[order(cc$Dim.1, decreasing = TRUE),]
  cc1$sum <- cumsum(cc1$Dim.1)
  dd <- cc1[which(cc1$sum<20),]
  eco_group <- rownames(dd)
  
  eig.val <- get_eigenvalue(eco.pca)  ## 选取特征值大于1的主成分数
  
  result <- list()
  result$cov <- re1
  result$eco.taxa <- eco_group
  result$pca <- eco.pca
  result$eig.val <- eig.val
  
  print("Well done!")
  return(result)
}
