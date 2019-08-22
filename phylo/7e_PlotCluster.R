#setwd("~/bigdata/Arundinaria/phylo/nuclear/")
#read in species data
species <- read.csv("~/bigdata/Arundinaria/phylo/JTCoords.csv", header=T)
species$Species <- gsub(pattern = "\\.", "", species$Species)
species$Species <- gsub(pattern = " ", "", species$Species)
#manually download altitude of each GPS coordinate
species$Altitude <- rep(c(633,700,681,516,503,546,313,515,601,604,543,445,46,46,20,40,43,94,611,198,118,149,84,69,76,121,21,7,92,78,77,112,54,40,176,307,131,95,110,163,119,237,202,196,130,172,643,602,528,350,261,385,233,230,282,281,228,117,199,40,1,5,6,6,3,142,84,140,56,46,171,140,42,21,171,172,286,84,196,196,196,196,196,196,196,196,196,196,196,196,196,196,196,196,196,196,196,196,196,196,196,196,196,196,185,185,185,185,185,185,185,185,185,185,84),3)

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

#Plot PCs against lat, long, and alt
mod1 <- lm(V3~Latitude, data=nucpca)
mod2 <- lm(V4~Latitude, data=nucpca)
mod3 <- lm(V5~Latitude, data=nucpca)
mod4 <- lm(V3~Longitude, data=nucpca)
mod5 <- lm(V4~Longitude, data=nucpca)
mod6 <- lm(V5~Longitude, data=nucpca)
mod7 <- lm(V3~Altitude, data=nucpca)
mod8 <- lm(V4~Altitude, data=nucpca)
mod9 <- lm(V5~Altitude, data=nucpca)

pdf(file="~/bigdata/Arundinaria/phylo/nuclear/NuclearPCvGeo.pdf", width=25, height=27)
  par(mfrow=c(3,3))
  plot(nucpca$Latitude, nucpca$V3, main=paste("PC1 v Latitude, p=",round(summary(mod1)$coefficients[2,4],3)), ylab="PC1", xlab="Latitude")
  abline(mod1) 
  plot(nucpca$Latitude, nucpca$V4, main=paste("PC2 v Latitude, p=",round(summary(mod2)$coefficients[2,4],3)), ylab="PC2", xlab="Latitude")
  abline(mod2) 
  plot(nucpca$Latitude, nucpca$V5, main=paste("PC3 v Latitude, p=",round(summary(mod3)$coefficients[2,4],3)), ylab="PC3", xlab="Latitude")
  abline(mod3) 
  plot(nucpca$Longitude, nucpca$V3, main=paste("PC1 v Longitude, p=",round(summary(mod4)$coefficients[2,4],3)), ylab="PC1", xlab="Longitude")
  abline(mod4) 
  plot(nucpca$Longitude, nucpca$V4, main=paste("PC2 v Longitude, p=",round(summary(mod5)$coefficients[2,4],3)), ylab="PC2", xlab="Longitude")
  abline(mod5) 
  plot(nucpca$Longitude, nucpca$V5, main=paste("PC3 v Longitude, p=",round(summary(mod6)$coefficients[2,4],3)), ylab="PC3", xlab="Longitude")
  abline(mod6)
  plot(nucpca$Altitude, nucpca$V3, main=paste("PC1 v Altitude, p=",round(summary(mod7)$coefficients[2,4],3)), ylab="PC1", xlab="Altitude")
  abline(mod7)
  plot(nucpca$Altitude, nucpca$V4, main=paste("PC2 v Altitude, p=",round(summary(mod8)$coefficients[2,4],3)), ylab="PC2", xlab="Altitude")
  abline(mod8)
  plot(nucpca$Altitude, nucpca$V5, main=paste("PC3 v Altitude, p=",round(summary(mod9)$coefficients[2,4],3)), ylab="PC3", xlab="Altitude")
  abline(mod9)
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

#Make MDS plot with ggplot for better labels
library(ggplot2)
library(ggrepel)
library(cowplot)
#make a color blind friendly palette
aruncol <- scale_color_manual(breaks = c("Ahybrid", "Aappalachiana", "Agigantea", "Atecta", "Unknown"), 
                              values = c("#440154FF", "#3B528BFF", "#21908CFF", "#5DC863FF", "#FDE725FF"))
pdf("NuclearMDSLabeled.pdf", width=11, height=9)
  ggplot(data = nucmds, aes(x = C1, y = C2, col=Species)) + 
    labs(title="Nuclear SNP MDS", x="Dimension 1", y="Dimension 2") +
    theme(axis.text.x = element_blank(),
          axis.text.y = element_blank(),
          axis.ticks = element_blank()) +
    geom_point(size = 3) +
    geom_text_repel(aes(label = FID)) +
    aruncol
dev.off()

#Plot MDS against lat, long, and alt
mod10 <- lm(C1~Latitude, data=nucmds)
mod11 <- lm(C2~Latitude, data=nucmds)
mod12 <- lm(C1~Longitude, data=nucmds)
mod13 <- lm(C2~Longitude, data=nucmds)
mod14 <- lm(C1~Altitude, data=nucmds)
mod15 <- lm(C2~Altitude, data=nucmds)

pdf(file="~/bigdata/Arundinaria/phylo/nuclear/NuclearMDSvGeo.pdf", width=18, height=27)
  par(mfrow=c(3,2))
  plot(nucmds$Latitude, nucmds$C1, main=paste("C1 v Latitude, p=",round(summary(mod10)$coefficients[2,4],3)), ylab="C1", xlab="Latitude")
  abline(mod10) 
  plot(nucmds$Latitude, nucmds$C2, main=paste("C2 v Latitude, p=",round(summary(mod11)$coefficients[2,4],3)), ylab="C2", xlab="Latitude")
  abline(mod11) 
  plot(nucmds$Longitude, nucmds$C1, main=paste("C1 v Longitude, p=",round(summary(mod12)$coefficients[2,4],3)), ylab="C1", xlab="Longitude")
  abline(mod12)
  plot(nucmds$Longitude, nucmds$C2, main=paste("C2 v Longitude, p=",round(summary(mod13)$coefficients[2,4],3)), ylab="C2", xlab="Longitude")
  abline(mod13) 
  plot(nucmds$Altitude, nucmds$C1, main=paste("C1 v Altitude, p=",round(summary(mod14)$coefficients[2,4],3)), ylab="C1", xlab="Altitude")
  abline(mod14)
  plot(nucmds$Altitude, nucmds$C2, main=paste("C2 v Altitude, p=",round(summary(mod15)$coefficients[2,4],3)), ylab="C2", xlab="Altitude")
  abline(mod15)
dev.off()


#### Repeat this with the Hull Road samples reduced to one
nucpcaHULL1 <- read.table("~/bigdata/Arundinaria/phylo/nuclear/NuclearH-2C.eigenvec")
nucpcaHULL1 <- merge(nucpcaHULL1, species, by.x="V1", by.y="Sample")
nucmdsHULL1 <- read.table("~/bigdata/Arundinaria/phylo/nuclear/NuclearH-2C.mds", header=T)
nucmdsHULL1 <- merge(nucmdsHULL1, species, by.x="FID", by.y="Sample")
pdf("NuclearHULL1PC1vPC2.pdf", width=11, height=9)
  plot(nucpcaHULL1$V3,nucpcaHULL1$V4, xlab="PC1", ylab="PC2", main="Nuclear SNP PCA", col=as.factor(nucpcaHULL1$Species), pch=16)
  legend("topright",legend=levels(as.factor(nucpcaHULL1$Species)),col=1:length(nucpcaHULL1$Species),pch=16, bty="n")
dev.off()
pdf("NuclearHULL1PC1vPC3.pdf", width=11, height=9)
  plot(nucpcaHULL1$V3,nucpcaHULL1$V5, xlab="PC1", ylab="PC3", main="Nuclear SNP PCA", col=as.factor(nucpcaHULL1$Species), pch=16)
  legend("topright",levels(as.factor(nucpcaHULL1$Species)),col=1:length(nucpcaHULL1$Species),pch=16, bty="n")
dev.off()
pdf("NuclearHULL1PC2vPC3.pdf", width=11, height=9)
  plot(nucpcaHULL1$V4,nucpcaHULL1$V5, xlab="PC2", ylab="PC3", main="Nuclear SNP PCA", col=as.factor(nucpcaHULL1$Species), pch=16)
  legend("topright",levels(as.factor(nucpcaHULL1$Species)),col=1:length(nucpcaHULL1$Species),pch=16, bty="n")
dev.off()
pdf("NuclearHULL1MDS.pdf", width=11, height=9)
  plot(nucmdsHULL1$C1,nucmdsHULL1$C2, xlab="Dim1", ylab="Dim2", main="Nuclear SNP MDS", col=as.factor(nucmdsHULL1$Species), pch=16)
  legend("bottomleft",legend=levels(as.factor(nucmdsHULL1$Species)),col=1:length(nucmdsHULL1$Species), pch=16, bty="n")
dev.off()

#### Repeat this with the Hull Road samples reduced to one
nucpcaHULL2 <- read.table("~/bigdata/Arundinaria/phylo/nuclear/NuclearH8D.eigenvec")
nucpcaHULL2 <- merge(nucpcaHULL2, species, by.x="V1", by.y="Sample")
nucmdsHULL2 <- read.table("~/bigdata/Arundinaria/phylo/nuclear/NuclearH8D.mds", header=T)
nucmdsHULL2 <- merge(nucmdsHULL2, species, by.x="FID", by.y="Sample")
pdf("NuclearHULL2PC1vPC2.pdf", width=11, height=9)
  plot(nucpcaHULL2$V3,nucpcaHULL2$V4, xlab="PC1", ylab="PC2", main="Nuclear SNP PCA", col=as.factor(nucpcaHULL2$Species), pch=16)
  legend("topright",legend=levels(as.factor(nucpcaHULL2$Species)),col=1:length(nucpcaHULL2$Species),pch=16, bty="n")
dev.off()
pdf("NuclearHULL2PC1vPC3.pdf", width=11, height=9)
  plot(nucpcaHULL2$V3,nucpcaHULL2$V5, xlab="PC1", ylab="PC3", main="Nuclear SNP PCA", col=as.factor(nucpcaHULL2$Species), pch=16)
  legend("topright",levels(as.factor(nucpcaHULL2$Species)),col=1:length(nucpcaHULL2$Species),pch=16, bty="n")
dev.off()
pdf("NuclearHULL2PC2vPC3.pdf", width=11, height=9)
  plot(nucpcaHULL2$V4,nucpcaHULL2$V5, xlab="PC2", ylab="PC3", main="Nuclear SNP PCA", col=as.factor(nucpcaHULL2$Species), pch=16)
  legend("topright",levels(as.factor(nucpcaHULL2$Species)),col=1:length(nucpcaHULL2$Species),pch=16, bty="n")
dev.off()
pdf("NuclearHULL2MDS.pdf", width=11, height=9)
  plot(nucmdsHULL2$C1,nucmdsHULL2$C2, xlab="Dim1", ylab="Dim2", main="Nuclear SNP MDS", col=as.factor(nucmdsHULL2$Species), pch=16)
  legend("bottomleft",legend=levels(as.factor(nucmdsHULL2$Species)),col=1:length(nucmdsHULL2$Species), pch=16, bty="n")
dev.off()

