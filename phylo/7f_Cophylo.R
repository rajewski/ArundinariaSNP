library(ape)
#on cluster
setwd("~/bigdata/Arundinaria/phylo/")
FourFull <- read.tree(file = "FullLength.newick")
FourColl <- read.tree(file = "FourSpeciesCollapsed.newick")
ThreeFull <- read.tree(file = "NoRiceFullLength.newick")
ThreeColl <- read.tree(file = "ThreeSpeciesCollapsed.newick")
association <- cbind(ThreeFull$tip.label,ThreeFull$tip.label)

#Scale branch lengths for better potting
FourFull$edge.length <- FourFull$edge.length*100
ThreeFull$edge.length <- ThreeFull$edge.length*100
FourColl$edge.length <- FourColl$edge.length*100
ThreeColl$edge.length <- ThreeColl$edge.length*100

#properly rotate trees
#this is sort of a kludge because I cant rotate the tree myself using ape, but dont 
#like the plotting functions of phytools as I understand them, so I've combined them
library(phytools)
comparetrees1 <- cophylo(FourFull, ThreeFull, assoc = association, rotate=TRUE, print=TRUE)
#save a waypoint
write.nexus(comparetrees1$trees[[1]], file = "FourFullRot.nex")
write.nexus(comparetrees1$trees[[2]], file = "ThreeFullRot.nex")

#the tree with polytomies takes waaay longer to sort out
comparetrees2 <- cophylo(FourColl, ThreeColl, assoc = association, print=TRUE, methods="post", rotate.multi=TRUE)
#save a waypoint
write.nexus(comparetrees2$trees[[1]], file = "FourCollRot.nex")
write.nexus(comparetrees2$trees[[2]], file = "ThreeCollRot.nex")