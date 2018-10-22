#With help from http://blog.phytools.org/2013/07/new-phytools-version-with-some.html
library(phytools)
setwd("~/Dropbox/Archive/UGA/Arundinaria/Analysis/WideSeq/Trees/")

# Get Coordinates and make a map range
Coords <- read.csv("../JTCoords.csv", row.names=1)
lat <- setNames(Coords$Latitude, as.character(rownames(Coords)))
long <- setNames(Coords$Longitude, as.character(rownames(Coords)))
ArunRange <- c("mississippi","alabama","georgia", "tennessee", "kentucky", "north carolina", "south carolina", "louisiana", "arkansas","missouri", "illinois", "virginia")

#Color by species
Aap <- rownames(Coords[Coords$Species=="A.appalachiana",])
Agi <- rownames(Coords[Coords$Species=="A.gigantea",])
Ate <- rownames(Coords[Coords$Species=="A.tecta",])
Unk <- rownames(Coords[Coords$Species=="Unknown",])
Ahy <- rownames(Coords[Coords$Species=="A. hybrid",])
colors <- matrix(NA, length(c(Aap, Ate, Agi, Ahy, Unk)),2, dimnames = list(c(Aap, Ate, Agi, Ahy, Unk)))
for( i in 1:length(Aap))
  colors[Aap[i],1:2] <- c("red","red")
for( i in 1:length(Agi))
  colors[Agi[i],1:2] <- c("green","green")
for( i in 1:length(Ate))
  colors[Ate[i],1:2] <- c("blue","blue")
for( i in 1:length(Ahy))
  colors[Ahy[i],1:2] <- c("violet","violet")
for( i in 1:length(Unk))
  colors[Unk[i],1:2] <- c("grey","grey")

# Read in trees and drop tips without coordinate information
Plastid <- read.tree("RAxML_bestTree.Plastid.RAxML")
Plastid <- drop.tip(Plastid,Plastid$tip.label[-match(rownames(Coords), Plastid$tip.label, nomatch = 0)])
WXY <- read.tree("RAxML_bestTree.WXY.RAxML_rerooted.newick")
WXY <- drop.tip(WXY, WXY$tip.label[-match(rownames(Coords), WXY$tip.label, nomatch = 0)])
LFY <- read.tree("RAxML_bestTree.LFY.RAxML")
LFY <- drop.tip(LFY, LFY$tip.label[-match(rownames(Coords), LFY$tip.label, nomatch = 0)])

# Plot Plastid Tree
pdf(file="PlastidML Map.pdf", width=10, height=7)
PlastidMap <- phylo.to.map(Plastid, cbind(lat, long), pts=FALSE, database="state", regions=ArunRange, fsize=.6, psize=0.9, from.tip=TRUE, colors=colors, ftype="off", mar=c(0.1, 0.1, 1.5, 0.1))
legend(x="bottomright", legend = c("A. gigantea", "A. tecta", "A. appalachiana", "Putative Hybrid", "Unknown"), text.font=c(3,3,3,1,1), pch=21, pt.cex=1.7, pt.bg = c("green", "blue", "red", "violet", "grey"), box.col = "transparent", bg="transparent", cex=1)
title(main="Plastid ML Phylogeny")
dev.off()

# Simplify Tree by dropping non-unique Hull/Tallassee Samples
HullDups <- rownames(Coords[(Coords$Species=="Unknown") & !(rownames(Coords) %in% c("H8B", "H8C", "H10C", "H4C")),])
HullDups <- c(HullDups, "L132", "L5", "L62", "65", "L93", "Lo16", "Lo28", "Lo43", "Lo9")
PlastidUniq <- drop.tip(Plastid, HullDups)
# Plot Unique Plastid Tree
phylo.to.map(PlastidUniq, cbind(lat, long), pts=FALSE, database="state", regions=ArunRange, fsize=.6, psize=0.9, from.tip=TRUE, colors=colors) 

# Plot LFY Tree
pdf(file="LFYML Map.pdf", width=10, height=7)
phylo.to.map(LFY, cbind(lat, long), pts=FALSE, database="state", regions=ArunRange, fsize=.6, psize=0.9, from.tip=TRUE, colors=colors, ftype="off", mar=c(0.1, 0.1, 1.5,0.1)) 
legend(x="bottomright", legend = c("A. gigantea", "A. tecta", "A. appalachiana", "Putative Hybrid", "Unknown"), text.font=c(3,3,3,1,1), pch=21, pt.cex=1.7, pt.bg = c("green", "blue", "red", "violet", "grey"), box.col = "transparent", bg="transparent", cex=1)
title(main="LFY ML Phylogeny")
dev.off()

# Plot WXY Tree
pdf(file="WXYML Map.pdf", width=10, height=7)
phylo.to.map(WXY, cbind(lat, long), pts=FALSE, database="state", regions=ArunRange, psize=0.9, from.tip=TRUE, colors=colors, ftype="off", mar=c(0.1, 0.1, 1.5,0.1)) 
legend(x="bottomright", legend = c("A. gigantea", "A. tecta", "A. appalachiana", "Putative Hybrid", "Unknown"), text.font=c(3,3,3,1,1), pch=21, pt.cex=1.7, pt.bg = c("green", "blue", "red", "violet", "grey"), box.col = "transparent", bg="transparent", cex=1)
title(main="WXY ML Phylogeny")
dev.off()
