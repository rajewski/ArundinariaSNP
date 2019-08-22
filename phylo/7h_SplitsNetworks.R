#This script needs as an input file, the .nex file from SplitsTree4 where:
# the alignment has been read in, distances calculated with uncorrect_p with averaged
# ambiguous sites, and outgroups and reference taxa removed. SplitsTree5 does not produce # the correct output file despite my best efforts.
library(phangorn)
setwd("/bigdata/littlab/arajewski/Arundinaria/phylo/")
splits <- read.nexus.networx("nuclear/Nuclear_ambig.fasta.nex")
#splits <- read.nexus.networx("concatenated/Concatenated_ambig.afa.nex")

# Read key table for label-to-sample matching.
label_ref <- read.csv("JTCoords.csv", header=T, stringsAsFactor = F)
label_ref$Species <- as.factor(gsub(pattern = "\\.| ", "", label_ref$Species))

# Create species vector by getting IDs from a named vector
species <- setNames(label_ref$Species, label_ref$Sample)[splits$tip.label]

# Rename tips as species
splits2 <- splits
splits2$tip.label <- as.character(species)

#set tip colors
colmap <- setNames(c("#440154FF", "#3B528BFF", "#21908CFF", "#5DC863FF", "#FDE725FF"),
                c("Ahybrid", "Aappalachiana", "Agigantea", "Atecta", "Unknown")
)
species2 <- colmap[as.character(species)]


# Write a plot with colored names showing phylo placement.
pdf(file = "nuclear/NuclearSNPSplits.pdf", width = 6, height = 4)
#pdf(file = "concatenated/ConcatenatedSNPSplits.pdf", width=6.5, height=6)

par(mar = rep(0, 4))
plot(splits, "2D", tip.col = species2,
	edge.width = 1.5, cex = 1, font = 3)
legend("bottomleft",legend=names(colmap),col=colmap, pch=16, bty="n")

dev.off()
