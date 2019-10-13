#This script needs as an input file, the .nex file from SplitsTree4 where:
# the alignment has been read in, distances calculated with uncorrect_p with averaged
# ambiguous sites, and outgroups and reference taxa removed. SplitsTree5 does not produce # the correct output file despite my best efforts.
library(phangorn)
setwd("/bigdata/littlab/arajewski/Arundinaria/phylo/")
splits <- read.nexus.networx("nuclear/Nuclear_ambig.fasta.nex")
#splits <- read.nexus.networx("concatenated/TESTconcatenated.nex.splits")
# for concatenated only
splits$tip.label <- gsub(pattern="_", "-", splits$tip.label)
splits$tip.label <- gsub(pattern="Gig", "Gig9", splits$tip.label)
splits$tip.label <- gsub(pattern="Tec", "Tec7", splits$tip.label)

# Read key table for label-to-sample matching.
label_ref <- read.csv("JTCoords.csv", header=T, stringsAsFactor = F)
label_ref$Species <- as.factor(gsub(pattern = "\\.| ", "", label_ref$Species))


# Create species vector by getting IDs from a named vector
species <- setNames(label_ref$Species, label_ref$Sample)[splits$tip.label]

#set tip colors
colmap <- setNames(c("#440154FF", "#3B528BFF", "#21908CFF", "#5DC863FF", "#FDE725FF"),
                c("Ahybrid", "Aappalachiana", "Agigantea", "Atecta", "Unknown")
)
species2 <- colmap[as.character(species)]


# Write a plot with colored names showing phylo placement.
pdf(file = "concatenated/ConcatenatedSNPSplits.pdf", width=7, height=6)
par(mar = c(0,0,2,0))
plot(splits, "2D",
     tip.col = species2,
     edge.width = 1.5, 
     cex = 1, 
     font = 3)
title(main = "Nuclear and Plastid SNP SplitsTree")
legend("topleft",legend=c("Hybrid", "A. appalachiana", "A. gigantea", "A. tecta", "Unknown"),col=colmap, pch=16, bty="n")
dev.off()

#plot nuclear only snps splitstree
pdf(file = "nuclear/NuclearSNPSplits.pdf", width = 7, height = 5)
par(mar = c(0,0,1,0))
plot(splits, "2D",
     tip.col = species2,
     edge.width = 1.5, 
     cex = 1, 
     font = 3)
title(main = "Nuclear SNP SplitsTree")
legend("bottomleft",legend=c("Hybrid", "A. appalachiana", "A. gigantea", "A. tecta", "Unknown"),col=colmap, pch=16, bty="n")
dev.off()
