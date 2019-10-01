library(phangorn)
library(ggplot2)
library(ggrepel)
library(cowplot)
setwd("/bigdata/littlab/arajewski/Arundinaria/phylo/")
x <- read.nexus.dist(file="nuclear/nuclear_ambig.dist")
#x <- read.nexus.dist(file="concatenated/TESTconatenated.dist")
x <- read.nexus.dist(file="LFY/LFY.dist")
fit <- cmdscale(x, eig=T, k=2)
eigenvec <- cbind(rownames(fit$points), fit$points[,1:2])

#read in species assignments
species <- read.csv("JTCoords.csv")
species$Species <- gsub(pattern = "\\.| " , "", species$Species)
species$Species <- substr(species$Species,1,4)

#make a color blind friendly palette
aruncol <- scale_color_manual(breaks = c("Ahyb", "Aapp", "Agig", "Atec", "Unkn"), 
                              values = c("#440154FF", "#3B528BFF", "#21908CFF", "#5DC863FF", "#FDE725FF"),
                              labels = c("Hybrid", "A. appalachiana", "A. gigantea", "A. tecta", "Unknown"))

#merge species names with eigenvector
mdsdata <- merge(eigenvec, species, by.x="V1", by.y="Sample")
mdsdata$V2 <- as.numeric(as.character(mdsdata$V2))
mdsdata$V3 <- as.numeric(as.character(mdsdata$V3))
mdsdata$Species <- as.factor(mdsdata$Species)

#pdf("concatenated/ConcatenatedMDSSplitsLabeled.pdf", width=11, height=9)
pdf("nuclear/NuclearMDSSplitsLabeled.pdf", width=11, height=9)
ggplot(data = mdsdata, aes(x = V3, y = V2, color=Species)) + 
  #labs(title="Nuclear and Plastid SNP MDS (SplitsTree)", x="Dimension 1", y="Dimension 2") +
  labs(title="Nuclear SNP MDS (SplitsTree)", x="Dimension 1", y="Dimension 2") +
  theme(axis.text.x = element_blank(),
        axis.text.y = element_blank(),
        axis.ticks = element_blank()) +
  geom_point(size = 3) +
  geom_text_repel(aes(label = V1)) +
  aruncol
dev.off()
