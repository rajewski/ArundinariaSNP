#setwd("~/bigdata/Arundinaria/phylo/nuclear/")
#read in species data
species <- read.csv("~/bigdata/Arundinaria/phylo/JTCoords.csv", header=T)
species$Species <- gsub(pattern = "\\.", "", species$Species)

#read PCA data
nucpca <- read.table("~/bigdata/Arundinaria/phylo/nuclear/Nuclear.eigenvec")
nucpca <- merge(nucpca, species, by.x="V1", by.y="Sample")

#PC1 v PC2
pdf("NuclearPC1vPC2.pdf", width=11, height=9)
  plot(nucpca$V3,nucpca$V4, xlab="PC1", ylab="PC2", main="Nuclear SNP PCA", col=as.factor(nucpca$Species), pch=16)
  #text(nucpca$V3,nucpca$V4, as.character(nucpca$V1))
  legend("topright",legend=levels(as.factor(nucpca$Species)),col=1:length(nucpca$Species),pch=16, bty="n")
dev.off()

#PC1 v PC3
pdf("NuclearPC1vPC3.pdf", width=11, height=9)
  plot(nucpca$V3,nucpca$V5, xlab="PC1", ylab="PC3", main="Nuclear SNP PCA", col=as.factor(nucpca$Species), pch=16)
  legend("topright",levels(as.factor(nucpca$Species)),col=1:length(nucpca$Species),pch=16, bty="n")
  #text(nucpca$V3,nucpca$V5, as.character(nucpca$V1))
dev.off()

#PC2 v PC3
pdf("NuclearPC2vPC3.pdf", width=11, height=9)
plot(nucpca$V4,nucpca$V5, xlab="PC2", ylab="PC3", main="Nuclear SNP PCA", col=as.factor(nucpca$Species), pch=16)
legend("topright",levels(as.factor(nucpca$Species)),col=1:length(nucpca$Species),pch=16, bty="n")
#text(nucpca$V3,nucpca$V5, as.character(nucpca$V1))
dev.off()

#PC2 v PC5
pdf("NuclearPC2vPC5.pdf", width=11, height=9)
plot(nucpca$V4,nucpca$V7, xlab="PC2", ylab="PC5", main="Nuclear SNP PCA", col=as.factor(nucpca$Species), pch=16)
legend("topright",levels(as.factor(nucpca$Species)),col=1:length(nucpca$Species),pch=16, bty="n")
#text(nucpca$V3,nucpca$V5, as.character(nucpca$V1))
dev.off()

#read MDS data
nucmds <- read.table("~/bigdata/Arundinaria/phylo/nuclear/Nuclear.mds", header=T)
nucmds <- merge(nucmds, species, by.x="FID", by.y="Sample")

#make the MDS plot
pdf("NuclearMDS.pdf", width=11, height=9)
  plot(nucmds$C1,nucmds$C2, xlab="Dim1", ylab="Dim2", main="Nuclear SNP MDS", col=as.factor(nucmds$Species), pch=16)
  legend("bottomleft",legend=levels(as.factor(nucmds$Species)),col=1:length(nucmds$Species), pch=16, bty="n")
  #text(nucmds$C1,nucmds$C2, as.character(nucmds$FID))
dev.off()
