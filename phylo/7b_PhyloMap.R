# This script should be run via the R docker container (arundinaRia) after you have sourced the
# container paths in 0_Paths.env and 0_Containers.env. You can either execute it with ${_arundinaRia[@]}
# followed by the DOCKER path to the script or interactively run the container by replacing the
# `--entrypoint` command and adding `-it`

# With help from http://blog.phytools.org/2013/07/new-phytools-version-with-some.html
library(phytools)

# Get Coordinates and make a map range
Coords <- read.csv("/mnt/References/HaploCoords.csv")
Coords$V1 <- NA
Coords$V2 <- NA
Coords$V3 <- NA
Coords[Coords$Species == "A.appalachiana", c("V1", "V2", "V3")] <- list("#000000FF", "#000000FF", 16)
Coords[Coords$Species == "A.tecta", c("V1", "V2", "V3")] <- list("#FFCC00FF", "#FFCC00FF", 16)
Coords[Coords$Species == "A.gigantea", c("V1", "V2", "V3")] <- list("#2A788EFF", "#2A788EFF", 16)
Coords[Coords$Species == "A. hybrid", c("V1", "V2", "V3")] <- list("#808080FF", "#808080FF", 4)
Coords[Coords$Species == "Unknown", c("V1", "V2", "V3")] <- list("#7AD151FF", "#7AD151FF", 16)

ArunRange <- c(
  "mississippi", "alabama", "georgia", "tennessee", "kentucky", "north carolina",
  "south carolina", "louisiana", "arkansas", "missouri", "illinois", "virginia"
)
lat <- setNames(Coords$Lat, as.character(Coords$Haplo))
long <- setNames(Coords$Long, as.character(Coords$Haplo))

# Assign colors -----------------------------------------------------------
# dont know how to specify which point coming from a single tip should be which color
cols <- Coords[, 5]
names(cols) <- Coords$Haplo
# Collapse Tecta and Appalachiana, assign a species to each haplotype where possible.
cpCols <- unique(Coords[grepl("cp_*", Coords$Haplo), c(1, 4, 5)]) # get only haplo and species for cp
cpCols <- cpCols[-c(2, 3, 5, 8, 9, 19, 29), ] # clean ambiguous out
cpCols$Species <- as.character(cpCols$Species)
cpCols[cpCols$Species == "A.tecta" | cpCols$Species == "A.appalachiana", "Species"] <- "Tec/App"
cpCols[cpCols$Species == "Tec/App", "V1"] <- "#FFCC00FF"
cpCols <- cpCols[, -2]
cpCols <- setNames(cpCols[, 2], cpCols[, 1])

LFYCols <- unique(Coords[grepl("LFY_*", Coords$Haplo), c(1, 4, 5)])
LFYCols <- LFYCols[-c(2, 22, 38), ] # clean ambiguous out
LFYCols$Species <- as.character(LFYCols$Species)
LFYCols[LFYCols$Species == "A.tecta" | LFYCols$Species == "A.appalachiana", "Species"] <- "Tec/App"
LFYCols[LFYCols$Species == "Tec/App", "V1"] <- "#FFCC00FF"
LFYCols <- LFYCols[, -2]
LFYCols <- setNames(LFYCols[, 2], LFYCols[, 1])

WXYCols <- unique(Coords[grepl("WXY_*", Coords$Haplo), c(1, 4, 5)])
WXYCols <- WXYCols[-c(1, 4, 5, 9, 17, 19, 29), ] # clean ambiguous out
WXYCols$Species <- as.character(WXYCols$Species)
WXYCols[WXYCols$Species == "A.tecta" | WXYCols$Species == "A.appalachiana", "Species"] <- "Tec/App"
WXYCols[WXYCols$Species == "Tec/App", "V1"] <- "#FFCC00FF"
WXYCols <- WXYCols[, -2]
WXYCols <- setNames(WXYCols[, 2], WXYCols[, 1])


# All Sample Map ----------------------------------------------------------
library(maps)
library(prettymapr)
pdf(file = "/mnt/Results/Figures/Map_AllSamples.pdf", height = 6, width = 6)
# png(file="/mnt/Results/Figures/Map_AllSamples.png", height=6, width=6, units="in", res=600)
map("state", ArunRange)
points(Coords$Long, Coords$Lat, col = Coords$V1, pch = Coords$V3)
legend("bottomright",
  legend = c("A. gigantea", "A. tecta", "A. appalachiana", "Hybrid", "Hull Rd"),
  text.font = c(3, 3, 3, 1, 1),
  pch = c(21, 21, 21, 4, 21),
  pt.cex = 1.7,
  pt.bg = c("#2A788EFF", "#FFCC00FF", "#000000FF", "#808080FF", "#7AD151FF"),
  box.col = "transparent",
  bg = "transparent",
  cex = .8
)
addscalebar(pos = "topright", padin = c(1.3, 0.5))
addnortharrow()
dev.off()

# Non-working section -----------------------------------------------------
# plot samples with shared Hull haplos
PlasHullShare <- c("JT27", "JT170", "JT172", "JT173", "JT178", "H8B")
WXYHullShareTec <- c("JT27", "H8B")
WXYHullShareGig <- c("JT85", "JT87", "JT98", "JT108", "JT167", "JT174", "JT183", "H8B")
LFYHullShare <- c("JT168", "JT171", "H8B")

## Missing the `species` object so this doesnt work
# map("state", ArunRange)
# # plastid
# points(species[species$Sample %in% PlasHullShare, ]$Longitude,
#   species[species$Sample %in% PlasHullShare, ]$Latitude,
#   col = species[species$Sample %in% PlasHullShare, ]$color,
#   pch = 16
# )
# # WXY
# points(species[species$Sample %in% WXYHullShareTec, ]$Longitude,
#   species[species$Sample %in% WXYHullShareTec, ]$Latitude,
#   col = species[species$Sample %in% WXYHullShareTec, ]$color,
#   pch = 16
# )
# points(species[species$Sample %in% WXYHullShareGig, ]$Longitude,
#   species[species$Sample %in% WXYHullShareGig, ]$Latitude,
#   col = species[species$Sample %in% WXYHullShareGig, ]$color,
#   pch = 16
# )
# # LFY
# points(species[species$Sample %in% LFYHullShare, ]$Longitude,
#   species[species$Sample %in% LFYHullShare, ]$Latitude,
#   col = species[species$Sample %in% LFYHullShare, ]$color,
#   pch = 16
# )

# Read in trees and drop tips without coordinate information
Plastid <- read.nexus("/mnt/Results/PHYLO/plastid/F81I/Plastid_NoMissingrenamed.nex.con.collapsed.tre")
Plastid <- drop.tip(Plastid, Plastid$tip.label[-match(Coords$Haplo, Plastid$tip.label, nomatch = 0)])

LFY <- read.nexus("/mnt/Results/PHYLO/LFY/HKYI/LFYrenamed.nex.con.collapsed.rot.tre")
LFY <- drop.tip(LFY, LFY$tip.label[-match(Coords$Haplo, LFY$tip.label, nomatch = 0)])

WXY <- read.nexus("/mnt/Results/PHYLO/WXY/SYMI/WXYrenamed.nex.con.collapsed.tre")
WXY <- root(WXY, outgroup = "WXY_Pedulis", resolve.root = T)
WXY <- drop.tip(WXY, WXY$tip.label[-match(Coords$Haplo, WXY$tip.label, nomatch = 0)])

PlastidJimmy <- read.nexus("/mnt/Results/PHYLO/plastid/F81I/Plastid_NoMissingrenamedJimmy.nex.con.collapsed.tre")
PlastidJimmy <- drop.tip(PlastidJimmy, PlastidJimmy$tip.label[-match(Coords$Haplo, PlastidJimmy$tip.label, nomatch = 0)])


# Connect Tree and Maps ---------------------------------------------------
# this section plots some (mostly uninformative) maps with phylogenies near them
# and lines connecting the location of a sample to its placement on the tree

# Plastid MrBayes F81I
pdf(file = "/mnt/Results/Figures/Map_Plastid_MrBayes_F81I.pdf", width = 8, height = 7)
PlastidMap <- phylo.to.map(Plastid, cbind(lat, long), pts = FALSE, database = "state", colors = cpCols, regions = ArunRange, fsize = .6, psize = 0.5, pch = 16, from.tip = TRUE, ftype = "off", mar = c(0.1, 0.1, 1.5, 0.1), rotate = T)
legend(
  x = "bottomright",
  legend = c("A. gigantea", "A. tecta/appal.", "Putative Hybrid", "Unknown"),
  text.font = c(3, 3, 1, 1),
  pch = 21,
  pt.cex = 1.7,
  pt.bg = c("#2A788EFF", "#FFCC00FF", "#808080FF", "#7AD151FF"),
  box.col = "transparent",
  bg = "transparent",
  cex = 1
)
title(main = "Collapsed Chloroplast Bayesian Phylogeny")
dev.off()

# Plastid MrBayes F81I Jimmy samples only
pdf(file = "/mnt/Results/Figures/Map_Plastid_MrBayes_F81I_JT.pdf", width = 8, height = 7)
PlastidMap <- phylo.to.map(PlastidJimmy, cbind(lat, long), pts = FALSE, database = "state", regions = ArunRange, fsize = .6, psize = 0.5, pch = 16, from.tip = TRUE, ftype = "off", mar = c(0.1, 0.1, 1.5, 0.1), rotate = T)
legend(
  x = "bottomright",
  legend = c("A. gigantea", "A. tecta/appal.", "Putative Hybrid", "Unknown"),
  text.font = c(3, 3, 1, 1),
  pch = 21,
  pt.cex = 1.7,
  pt.bg = c("#2A788EFF", "#FFCC00FF", "#808080FF", "#7AD151FF"),
  box.col = "transparent",
  bg = "transparent",
  cex = 1
)
title(main = "Collapsed Chloroplast Bayesian Phylogeny")
dev.off()

# LFY MrBayes HKYI
pdf(file = "/mnt/Results/Figures/Map_LFY_MrBayes_HKYI.pdf", width = 8, height = 7)
phylo.to.map(LFY, cbind(lat, long), pts = FALSE, database = "state", regions = ArunRange, fsize = .6, psize = 0.5, pch = 16, from.tip = TRUE, colors = LFYCols, ftype = "off", mar = c(0.1, 0.1, 1.5, 0.1))
legend(
  x = "bottomright",
  legend = c("A. gigantea", "A. tecta/appal.", "Putative Hybrid", "Unknown"),
  text.font = c(3, 3, 1, 1),
  pch = 21,
  pt.cex = 1.7,
  pt.bg = c("#2A788EFF", "#FFCC00FF", "#808080FF", "#7AD151FF"),
  box.col = "transparent",
  bg = "transparent",
  cex = 1
)
title(main = "Collapsed LFY Bayesian Phylogeny")
dev.off()

# WXY SYMI MrBayes
pdf(file = "/mnt/Results/Figures/Map_WXY_MrBayes_SYMI.pdf", width = 8, height = 7)
phylo.to.map(WXY, cbind(lat, long), pts = FALSE, database = "state", regions = ArunRange, psize = 0.5, pch = 16, from.tip = TRUE, colors = WXYCols, ftype = "off", mar = c(0.1, 0.1, 1.5, 0.1))
legend(
  x = "bottomright",
  legend = c("A. gigantea", "A. tecta/appal.", "Putative Hybrid", "Unknown"),
  text.font = c(3, 3, 1, 1),
  pch = 21,
  pt.cex = 1.7,
  pt.bg = c("#2A788EFF", "#FFCC00FF", "#808080FF", "#7AD151FF"),
  box.col = "transparent",
  bg = "transparent",
  cex = 1
)
title(main = "Collapsed WXY Bayesian Phylogeny")
dev.off()
