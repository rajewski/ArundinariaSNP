#With help from http://blog.phytools.org/2013/07/new-phytools-version-with-some.html
#library(devtools)
#install_github("liamrevell/phytools")
library(phytools)
setwd("~/bigdata/Arundinaria/phylo")

# Get Coordinates and make a map range
Coords <- read.csv("HaploCoords.csv")
Coords$V1 <- NA
Coords$V2 <- NA
Coords[Coords$Species=="A.appalachiana",c("V1", "V2")] <- c("red", "red")
Coords[Coords$Species=="A.tecta",c("V1", "V2")] <- c("blue", "blue")
Coords[Coords$Species=="A.gigantea",c("V1", "V2")] <- c("green", "green")
Coords[Coords$Species=="A. hybrid",c("V1", "V2")] <- c("violet", "violet")
Coords[Coords$Species=="Unknown",c("V1", "V2")] <- c("grey", "grey")

ArunRange <- c("mississippi","alabama","georgia", "tennessee", "kentucky", "north carolina", "south carolina", "louisiana", "arkansas","missouri", "illinois", "virginia")
lat <- setNames(Coords$Lat, as.character(Coords$Haplo))
long <- setNames(Coords$Long, as.character(Coords$Haplo))

# Assign colors
# dont know how to specify which point coming from a single tip should be which color
cols <- Coords[,5]
names(cols) <- Coords$Haplo
#Collapse Tecta and Appalachiana, assign a species to each haplotype where possible.
cpCols <- unique(Coords[grepl("cp_*", Coords$Haplo),c(1,4,5)]) #get only haplo and species for cp
cpCols <- cpCols[-c(2,3,5,8,9,19,29),] #clean ambiguous out
cpCols$Species <- as.character(cpCols$Species)
cpCols[cpCols$Species=="A.tecta" | cpCols$Species=="A.appalachiana","Species"] <- "Tec/App"
cpCols[cpCols$Species=="Tec/App","V1"] <- "blue"
cpCols <- cpCols[,-2]
cpCols <- setNames(cpCols[,2], cpCols[,1])

LFYCols <- unique(Coords[grepl("LFY_*", Coords$Haplo),c(1,4,5)])
LFYCols <- LFYCols[-c(2,22,38),] #clean ambiguous out
LFYCols$Species <- as.character(LFYCols$Species)
LFYCols[LFYCols$Species=="A.tecta" | LFYCols$Species=="A.appalachiana","Species"] <- "Tec/App"
LFYCols[LFYCols$Species=="Tec/App","V1"] <- "blue"
LFYCols <- LFYCols[,-2]
LFYCols <- setNames(LFYCols[,2], LFYCols[,1])

WXYCols <- unique(Coords[grepl("WXY_*", Coords$Haplo),c(1,4,5)])
WXYCols <- WXYCols[-c(1,4,5,9,17, 19, 29),] #clean ambiguous out
WXYCols$Species <- as.character(WXYCols$Species)
WXYCols[WXYCols$Species=="A.tecta" | WXYCols$Species=="A.appalachiana","Species"] <- "Tec/App"
WXYCols[WXYCols$Species=="Tec/App","V1"] <- "blue"
WXYCols <- WXYCols[,-2]
WXYCols <- setNames(WXYCols[,2], WXYCols[,1])


# Read in trees and drop tips without coordinate information
Plastid <- read.nexus("plastid/F81I/Plastid_NoMissingrenamed.nex.con.collapsed.tre")
Plastid <- drop.tip(Plastid,Plastid$tip.label[-match(Coords$Haplo, Plastid$tip.label, nomatch = 0)])
LFY <- read.nexus("LFY/HKYI/LFYrenamed.nex.con.collapsed.rot.tre")
LFY <- drop.tip(LFY, LFY$tip.label[-match(Coords$Haplo, LFY$tip.label, nomatch = 0)])
WXY <- read.nexus("WXY/SYMI/WXYrenamed.nex.con.collapsed.tre")
WXY <- root(WXY, outgroup="WXY_Pedulis", resolve.root=T)
WXY <- drop.tip(WXY, WXY$tip.label[-match(Coords$Haplo, WXY$tip.label, nomatch = 0)])
PlastidJimmy <- read.nexus("plastid/F81I/Plastid_NoMissingrenamedJimmy.nex.con.collapsed.tre")
PlastidJimmy <- drop.tip(PlastidJimmy,PlastidJimmy$tip.label[-match(Coords$Haplo, PlastidJimmy$tip.label, nomatch = 0)])

# Plot Plastid Tree
pdf(file="plastid/F81I/Plastid Bayesian Map.pdf", width=15, height=7)
  PlastidMap <- phylo.to.map(Plastid, cbind(lat, long), pts=FALSE, database="state", colors=cpCols, regions=ArunRange, fsize=.6, psize=0.5, pch=16, from.tip=TRUE, ftype="off", mar=c(0.1, 0.1, 1.5, 0.1), rotate=T)
  # legend(x="bottomright", legend = c("A. gigantea", "A. tecta", "A. appalachiana", "Putative Hybrid", "Unknown"), text.font=c(3,3,3,1,1), pch=21, pt.cex=1.7, pt.bg = c("green", "blue", "red", "violet", "grey"), box.col = "transparent", bg="transparent", cex=1)
  legend(x="bottomright", legend = c("A. gigantea", "A. tecta/appal.", "Putative Hybrid", "Unknown"), text.font=c(3,3,1,1), pch=21, pt.cex=1.7, pt.bg = c("green", "blue", "violet", "grey"), box.col = "transparent", bg="transparent", cex=1)
  title(main="Collapsed Chloroplast Bayesian Phylogeny")
dev.off()

# Plot Plastid Jimmy Tree
pdf(file="plastid/F81I/Plastid Jimmy Bayesian Map.pdf", width=15, height=7)
  PlastidMap <- phylo.to.map(PlastidJimmy, cbind(lat, long), pts=FALSE, database="state", regions=ArunRange, fsize=.6, psize=0.5, pch=16, from.tip=TRUE, ftype="off", mar=c(0.1, 0.1, 1.5, 0.1), rotate=T)
  # legend(x="bottomright", legend = c("A. gigantea", "A. tecta", "A. appalachiana", "Putative Hybrid", "Unknown"), text.font=c(3,3,3,1,1), pch=21, pt.cex=1.7, pt.bg = c("green", "blue", "red", "violet", "grey"), box.col = "transparent", bg="transparent", cex=1)
  legend(x="bottomright", legend = c("A. gigantea", "A. tecta/appal.", "Putative Hybrid", "Unknown"), text.font=c(3,3,1,1), pch=21, pt.cex=1.7, pt.bg = c("green", "blue", "violet", "grey"), box.col = "transparent", bg="transparent", cex=1)
  title(main="Collapsed Chloroplast Bayesian Phylogeny")
dev.off()


# Plot LFY Tree
pdf(file="LFY/HKYI/LFY Bayesian Map.pdf", width=10, height=7)
  phylo.to.map(LFY, cbind(lat, long), pts=FALSE, database="state", regions=ArunRange, fsize=.6, psize=0.5, pch=16, from.tip=TRUE, colors=LFYCols, ftype="off", mar=c(0.1, 0.1, 1.5,0.1)) 
  # legend(x="bottomright", legend = c("A. gigantea", "A. tecta", "A. appalachiana", "Putative Hybrid", "Unknown"), text.font=c(3,3,3,1,1), pch=21, pt.cex=1.7, pt.bg = c("green", "blue", "red", "violet", "grey"), box.col = "transparent", bg="transparent", cex=1)
  legend(x="bottomright", legend = c("A. gigantea", "A. tecta/appal.", "Putative Hybrid", "Unknown"), text.font=c(3,3,1,1), pch=21, pt.cex=1.7, pt.bg = c("green", "blue", "violet", "grey"), box.col = "transparent", bg="transparent", cex=1)
  title(main="Collapsed LFY Bayesian Phylogeny")
dev.off()

# Plot WXY Tree
pdf(file="WXY/SYMI/WXY Bayesian Map.pdf", width=10, height=7)
  phylo.to.map(WXY, cbind(lat, long), pts=FALSE, database="state", regions=ArunRange, psize=0.5, pch=16, from.tip=TRUE, colors=WXYCols, ftype="off", mar=c(0.1, 0.1, 1.5,0.1)) 
  # legend(x="bottomright", legend = c("A. gigantea", "A. tecta", "A. appalachiana", "Putative Hybrid", "Unknown"), text.font=c(3,3,3,1,1), pch=21, pt.cex=1.7, pt.bg = c("green", "blue", "red", "violet", "grey"), box.col = "transparent", bg="transparent", cex=1)
  legend(x="bottomright", legend = c("A. gigantea", "A. tecta/appal.", "Putative Hybrid", "Unknown"), text.font=c(3,3,1,1), pch=21, pt.cex=1.7, pt.bg = c("green", "blue", "violet", "grey"), box.col = "transparent", bg="transparent", cex=1)
  title(main="Collapsed WXY Bayesian Phylogeny")
dev.off()
