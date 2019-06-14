setwd("~/bigdata/Arundinaria/phylo/")

library(ape)
library(phytools)

# This script runs the same analysis for three loci. It reads in a set of either resolved or collapsed 
# Bayesian trees, rotates them to align taxon labels, and saves the rotated trees for later plotting. 
# This is only done if the rotate tree file does not exist in order to save computing time.

# directly importing from MrBayes does not parse the posterior probabilities well. So I am trimming
# that metadata down with TreeGraph and saving it with branch support (0-1). 
# I had to manually edit the taxon labels to re-add the underscore in the name of the nexus file, 
# and it KILLS me to use that program even more.

# Resolved trees for LFY
if (!file.exists("LFY/HKYI/LFYrenamed.nex.con.rot.tre") && !file.exists("LFY/HKYI/LFYrenamedJimmy.nex.con.rot.tre")) {
  All <- read.nexus("LFY/HKYI/LFYrenamed.nex.con2.tre") #FIX this with TreeGraph
  Jimmy <- read.nexus("LFY/HKYI/LFYrenamedJimmy.nex.con2.tre")
  comparetrees <- cophylo(All, Jimmy, rotate=TRUE, print=TRUE)
  write.nexus(comparetrees$trees[[1]], file = "LFY/HKYI/LFYrenamed.nex.con.rot.tre")
  write.nexus(comparetrees$trees[[2]], file = "LFY/HKYI/LFYrenamedJimmy.nex.con.rot.tre")
  rm(All, Jimmy, comparetrees)
}

# Resolved trees for WXY
if (!file.exists("WXY/SYMI/WXYrenamed.nex.con.rot.tre") && !file.exists("WXY/SYMI/WXYrenamedJimmy.nex.con.rot.tre")) {
  All <- read.nexus("WXY/SYMI/WXYrenamed.nex.con2.tre") 
  Jimmy <- read.nexus("WXY/SYMI/WXYrenamedJimmy.nex.con2.tre")
  comparetrees <- cophylo(All, Jimmy, rotate=TRUE, print=TRUE)
  write.nexus(comparetrees$trees[[1]], file = "WXY/SYMI/WXYrenamed.nex.con.rot.tre")
  write.nexus(comparetrees$trees[[2]], file = "WXY/SYMI/WXYrenamedJimmy.nex.con.rot.tre")
  rm(All, Jimmy, comparetrees)
}

# Resolved plastid trees
if (!file.exists("plastid/F81I/Plastid_NoMissingrenamed.nex.con.rot.tre") && !file.exists("plastid/F81I/Plastid_NoMissingrenamedJimmy.nex.con.rot.tre")) {
  All <- read.nexus("plastid/F81I/Plastid_NoMissingrenamed.nex.con2.tre")  
  Jimmy <- read.nexus("plastid/F81I/Plastid_NoMissingrenamedJimmy.nex.con2.tre")
  comparetrees <- cophylo(All, Jimmy, rotate=TRUE, print=TRUE)
  write.nexus(comparetrees$trees[[1]], file = "plastid/F81I/Plastid_NoMissingrenamed.nex.con.rot.tre")
  write.nexus(comparetrees$trees[[2]], file = "plastid/F81I/Plastid_NoMissingrenamedJimmy.nex.con.rot.tre")
  rm(All, Jimmy, comparetrees)
}

# I can't find an R pckage to collapse trees by support, so I am doing it in TreeGraph as well
# looking at the general cophylo plots, I think I can actually rotate them by hand quicker than the HPCC
# The algorithm does an exhaustive search of every possible rotation, but by eye only a few corrections are needed.
# I just did this by hand manually editing the nexus file and saved it (for LFY All only)


