# This script should be run via the R docker container (arundinaRia) after you have sourced the
# container paths in 0_Paths.env and 0_Containers.env. You can either execute it with ${_arundinaRia[@]}
# followed by the DOCKER path to the script or interactively run the container by replacing the
# `--entrypoint` command and adding `-it`

# Note: This script needs as an input, the .nex files from SplitsTree4 where
# the alignment has been read in, distances calculated with uncorrect_p with averaged
# ambiguous sites, and outgroups and reference taxa removed. Each run produces both a `.splits.nex` file
# used for making the network itself and a `.dist.nex` with the distances used for making the MDS plots

# Note: Like MrBayes and RAxML, I have not made an attempt to put splitstree into a docker container.
# The software needs a gui, is java-based, and is tricky on the best of days, so I dont want to mess
# with it. You must read in an alignment (e.g. Nuclear_ambig.fasta) to SplitsTree, calculating a
# distance matrix with the uncorrected_p method averaging ambiguous sites, and exporting it.

# Plot Networks -----------------------------------------------------------
library(phangorn)

# Read in splits
# splits <- read.nexus.networx("/mnt/Results/PHYLO/nuclear/Nuclear_ambig.fasta.nex")
splits <- read.nexus.networx("/mnt/Results/PHYLO/concatenated/TESTconcatenated.nex.splits")

# Clean Labels (for concatenated only)
splits$tip.label <- gsub(pattern = "_", "-", splits$tip.label)
splits$tip.label <- gsub(pattern = "Gig", "Gig9", splits$tip.label)
splits$tip.label <- gsub(pattern = "Tec", "Tec7", splits$tip.label)

# Read key table for label-to-sample matching.
label_ref <- read.csv("/mnt/References/JTCoords.csv", header = T, stringsAsFactor = F)
label_ref$Species <- as.factor(gsub(pattern = "\\.| ", "", label_ref$Species))

# Create species vector by getting IDs from a named vector
species <- setNames(label_ref$Species, label_ref$Sample)[splits$tip.label]

# set tip colors
colmap <- setNames(
  c("#440154FF", "#3B528BFF", "#21908CFF", "#5DC863FF", "#FDE725FF"),
  c("Ahybrid", "Aappalachiana", "Agigantea", "Atecta", "Unknown")
)

species2 <- colmap[as.character(species)]


# Plot with colored names showing phylo placement.
pdf(file = "/mnt/Results/Figures/Splits_concatenated.pdf", width = 7, height = 6)
par(mar = c(0, 0, 2, 0))
plot(splits, "2D",
  tip.col = species2,
  edge.width = 1.5,
  cex = 1,
  font = 3
)
title(main = "Nuclear and Plastid SNP SplitsTree")
legend("topleft", legend = c("Hybrid", "A. appalachiana", "A. gigantea", "A. tecta", "Unknown"), col = colmap, pch = 16, bty = "n")
dev.off()

# plot nuclear only snps splitstree
pdf(file = "/mnt/Results/Figures/Splits_Nuclear.pdf", width = 7, height = 5)
par(mar = c(0, 0, 1, 0))
plot(splits, "2D",
  tip.col = species2,
  edge.width = 1.5,
  cex = 1,
  font = 3
)
title(main = "Nuclear SNP SplitsTree")
legend("bottomleft", legend = c("Hybrid", "A. appalachiana", "A. gigantea", "A. tecta", "Unknown"), col = colmap, pch = 16, bty = "n")
dev.off()

# Plot MDS ----------------------------------------------------------------
library(ggplot2)
library(ggrepel)
library(cowplot)
# x <- read.nexus.dist(file = "/mnt/Results/PHYLO/nuclear/nuclear_ambig.dist")
x <- read.nexus.dist(file = "/mnt/Results/PHYLO/concatenated/TESTconatenated.dist")
# x <- read.nexus.dist(file = "/mnt/Results/PHYLO/LFY/LFY.dist.nex")
fit <- cmdscale(x, eig = T, k = 2)
eigenvec <- cbind(rownames(fit$points), fit$points[, 1:2])

# read in species assignments
species <- read.csv("/mnt/References/JTCoords.csv")
species$Species <- gsub(pattern = "\\.| ", "", species$Species)
species$Species <- substr(species$Species, 1, 4)

# make a color blind friendly palette
aruncol <- scale_color_manual(
  breaks = c("Ahyb", "Aapp", "Agig", "Atec", "Unkn"),
  values = c("#440154FF", "#3B528BFF", "#21908CFF", "#5DC863FF", "#FDE725FF"),
  labels = c("Hybrid", "A. appalachiana", "A. gigantea", "A. tecta", "Unknown")
)

# merge species names with eigenvector
mdsdata <- merge(eigenvec, species, by.x = "V1", by.y = "Sample")
mdsdata$V2 <- as.numeric(as.character(mdsdata$V2))
mdsdata$V3 <- as.numeric(as.character(mdsdata$V3))
mdsdata$Species <- as.factor(mdsdata$Species)

pdf("/mnt/Results/Figures/MDS_Concatenated_SplitsTree_Labeled.pdf", width = 11, height = 9)
# pdf("/mnt/Results/Figures/MDS_Nuclear_SplitsTree_Labeled.pdf", width = 11, height = 9)
ggplot(data = mdsdata, aes(x = V3, y = V2, color = Species)) +
  # labs(title="Nuclear and Plastid SNP MDS (SplitsTree)", x="Dimension 1", y="Dimension 2") +
  labs(title = "WXY SNP MDS (SplitsTree)", x = "Dimension 1", y = "Dimension 2") +
  theme(
    axis.text.x = element_blank(),
    axis.text.y = element_blank(),
    axis.ticks = element_blank()
  ) +
  geom_point(size = 3) +
  geom_text_repel(aes(label = V1)) +
  aruncol +
  theme_cowplot()
dev.off()
