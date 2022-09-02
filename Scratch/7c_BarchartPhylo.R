# This script should be run via the R docker container (arundinaRia) after you have sourced the
# container paths in 0_Paths.env and 0_Containers.env. You can either execute it with ${_arundinaRia[@]}
# followed by the DOCKER path to the script or interactively run the container by replacing the
# `--entrypoint` command and adding `-it`

# Note: I think this script might not be worth converting since none of its plots made it into the
# final manuscript I won't touch anything below this line, and I'll archive this and other old analyses.

library(phytools)
setwd("~/bigdata/Arundinaria/phylo/")
# assign colors for legend
colors <- setNames(c("red", "green", "pink", "blue", "grey"), c("pApp", "pGig", "pHyb", "pTec", "pUnk"))


# LFY Phased All Samples --------------------------------------------------
LFY <- read.nexus("~/bigdata/Arundinaria/phylo/LFY/HKYI/LFYrenamed.nex.con.collapsed.rot.tre") # import prerooted tree
LFY <- root(LFY, outgroup = "LFY_Pedulis", resolve.root = T)
LFY <- drop.tip(LFY, "LFY_Pedulis")
# read in list of percents
LFYprops <- read.csv("rename.csv", header = T)[27:119, c(1, 8:12)]
row.names(LFYprops) <- LFYprops[, 1]
LFYprops <- LFYprops[, -1]
LFYprops <- LFYprops[order(match(row.names(LFYprops), LFY$tip.label)), ]

# Plot it
pdf("~/bigdata/Arundinaria/phylo/LFY/HKYI/LFY All Phased Barplot.pdf", height = 20, width = 10)
plotTree.barplot(LFY, LFYprops[LFY$tip.label, ], args.plotTree = list(show.node.label = T), args.barplot = list(col = colors, main = "Species Assignment", border = NA), arg.axis = list(axes = FALSE), legend.text = T)
legend(x = "topright", legend = names(colors), pch = 22, pt.cex = 2, pt.bg = colors, ncol = 5, box.col = "transparent")
dev.off()

# WXY Phased All Samples --------------------------------------------------
WXY <- read.nexus("~/bigdata/Arundinaria/phylo/WXY/SYMI/WXYrenamed.nex.con.collapsed.tre")
WXY <- root(WXY, outgroup = "WXY_Pedulis", resolve.root = T)
WXY <- drop.tip(WXY, "WXY_Pedulis")
# read in list of percents
WXYprops <- read.csv("~/bigdata/Arundinaria/phylo/rename.csv", header = T)[120:147, c(1, 8:12)]
row.names(WXYprops) <- WXYprops[, 1]
WXYprops <- WXYprops[, -1]
WXYprops <- WXYprops[order(match(row.names(WXYprops), WXY$tip.label)), ]

# Plot it
pdf("~/bigdata/Arundinaria/phylo/WXY/SYMI/WXY All Phased Barplot.pdf", height = 15, width = 10)
plotTree.barplot(WXY, WXYprops[c(WXY$tip.label[-12], WXY$tip.label[12]), ], args.plotTree = list(show.node.label = T), args.barplot = list(col = colors, main = "Species Assignment", border = NA), arg.axis = list(axes = FALSE), legend.text = T)
legend(x = "topright", legend = names(colors), pch = 22, pt.cex = 2, pt.bg = colors, ncol = 5, box.col = "transparent")
dev.off()

# Plastid Phased All Samples ----------------------------------------------
plastid <- read.nexus("~/bigdata/Arundinaria/phylo/plastid/F81I/Plastid_NoMissingrenamed.nex.con.collapsed.tre") # import prerooted tree
plastid <- root(plastid, outgroup = "cp_Pedulis", resolve.root = T)
plastid <- drop.tip(plastid, "cp_Pedulis")

# read in list of percents
plastidprops <- read.csv("~/bigdata/Arundinaria/phylo/rename.csv", header = T)[1:26, c(1, 8:12)]
row.names(plastidprops) <- plastidprops[, 1]
plastidprops <- plastidprops[, -1]
plastidprops <- plastidprops[order(match(row.names(plastidprops), plastid$tip.label)), ]

# Plot it
pdf("~/bigdata/Arundinaria/phylo/plastid/F81I/Plastid Phased All Barplot.pdf", height = 13, width = 10)
plotTree.barplot(plastid, plastidprops[plastid$tip.label, ], args.plotTree = list(show.node.label = T), args.barplot = list(col = colors, main = "Species Assignment", border = NA), arg.axis = list(axes = FALSE), legend.text = T)
legend(x = "topright", legend = names(colors), pch = 22, pt.cex = 2, pt.bg = colors, ncol = 5, box.col = "transparent")
dev.off()






# LFY Phased Jimmy Samples ------------------------------------------------
LFYj <- read.nexus("~/bigdata/Arundinaria/phylo/LFY/HKYI/LFYrenamedJimmy.nex.con.collapsed.tre") # import prerooted tree
LFYj <- root(LFYj, outgroup = "LFY_Pedulis", resolve.root = T)
LFYj <- drop.tip(LFYj, "LFY_Pedulis")
# read in list of percents
LFYjprops <- read.csv("rename.csv", header = T)[, c(1, 8:12)]
row.names(LFYjprops) <- LFYjprops[, 1]
LFYjprops <- LFYjprops[, -1]
LFYjprops <- LFYjprops[LFYj$tip.label, ]
LFYjprops <- LFYjprops[order(match(row.names(LFYjprops), LFYj$tip.label)), ]

# Plot it
pdf("~/bigdata/Arundinaria/phylo/LFY/HKYI/LFY Jimmy Phased Barplot.pdf", height = 20, width = 10)
plotTree.barplot(LFYj, LFYjprops[LFYj$tip.label, ], args.plotTree = list(show.node.label = T), args.barplot = list(col = colors, main = "Species Assignment", border = NA), arg.axis = list(axes = FALSE), legend.text = T)
legend(x = "topright", legend = names(colors), pch = 22, pt.cex = 2, pt.bg = colors, ncol = 5, box.col = "transparent")
dev.off()

# WXY Phased Jimmy Samples ------------------------------------------------
WXYj <- read.nexus("~/bigdata/Arundinaria/phylo/WXY/SYMI/WXYrenamedJimmy.nex.con.collapsed.tre") # import prerooted tree
WXYj <- root(WXYj, outgroup = "WXY_Pedulis", resolve.root = T)
WXYj <- drop.tip(WXYj, "WXY_Pedulis")
# read in list of percents
WXYjprops <- read.csv("rename.csv", header = T)[, c(1, 8:12)]
row.names(WXYjprops) <- WXYjprops[, 1]
WXYjprops <- WXYjprops[, -1]
WXYjprops <- WXYjprops[WXYj$tip.label, ]
WXYjprops <- WXYjprops[order(match(row.names(WXYjprops), WXYj$tip.label)), ]

# Plot it
pdf("~/bigdata/Arundinaria/phylo/WXY/SYMI/WXY Jimmy Phased Barplot.pdf", height = 20, width = 10)
plotTree.barplot(WXYj, WXYjprops[WXYj$tip.label, ], args.plotTree = list(show.node.label = T), args.barplot = list(col = colors, main = "Species Assignment", border = NA), arg.axis = list(axes = FALSE), legend.text = T)
legend(x = "topright", legend = names(colors), pch = 22, pt.cex = 2, pt.bg = colors, ncol = 5, box.col = "transparent")
dev.off()

# Plastid Phased Jimmy Samples --------------------------------------------
plastidj <- read.nexus("~/bigdata/Arundinaria/phylo/plastid/F81I/Plastid_NoMissingrenamedJimmy.nex.con.collapsed.tre") # import prerooted tree
plastidj <- root(plastidj, outgroup = "cp_Pedulis", resolve.root = T)
plastidj <- drop.tip(plastidj, "cp_Pedulis")
# read in list of percents
plastidjprops <- read.csv("rename.csv", header = T)[, c(1, 8:12)]
row.names(plastidjprops) <- plastidjprops[, 1]
plastidjprops <- plastidjprops[, -1]
plastidjprops <- plastidjprops[plastidj$tip.label, ]
plastidjprops <- plastidjprops[order(match(row.names(plastidjprops), plastidj$tip.label)), ]

# Plot it
pdf("~/bigdata/Arundinaria/phylo/plastid/F81I/Plastid Jimmy Phased Barplot.pdf", height = 14.5, width = 10)
plotTree.barplot(plastidj, plastidjprops[plastidj$tip.label, ], args.plotTree = list(show.node.label = T), args.barplot = list(col = colors, main = "Species Assignment", border = NA), arg.axis = list(axes = FALSE), legend.text = T)
legend(x = "topright", legend = names(colors), pch = 22, pt.cex = 2, pt.bg = colors, ncol = 5, box.col = "transparent")
dev.off()





# Plot all ----------------------------------------------------------------
pdf("~/bigdata/Arundinaria/phylo/All Loci Barplot.pdf", height = 40, width = 40)
par(mfrow = c(2, 6))
plotTree.barplot(LFY, LFYprops[LFY$tip.label, ], args.plotTree = list(show.node.label = T), args.barplot = list(col = colors, main = "Species Assignment", border = NA), arg.axis = list(axes = FALSE), legend.text = T, add = T)
plotTree.barplot(WXY, WXYprops[c(WXY$tip.label[-12], WXY$tip.label[12]), ], args.plotTree = list(show.node.label = T), args.barplot = list(col = colors, main = "Species Assignment", border = NA), arg.axis = list(axes = FALSE), legend.text = T, add = T)
plotTree.barplot(plastid, plastidprops[plastid$tip.label, ], args.plotTree = list(show.node.label = T), args.barplot = list(col = colors, main = "Species Assignment", border = NA), arg.axis = list(axes = FALSE), legend.text = T, add = T)
plotTree.barplot(LFYj, LFYjprops[LFYj$tip.label, ], args.plotTree = list(show.node.label = T), args.barplot = list(col = colors, main = "Species Assignment", border = NA), arg.axis = list(axes = FALSE), legend.text = T, add = T)
plotTree.barplot(WXYj, WXYjprops[WXYj$tip.label, ], args.plotTree = list(show.node.label = T), args.barplot = list(col = colors, main = "Species Assignment", border = NA), arg.axis = list(axes = FALSE), legend.text = T, add = T)
plotTree.barplot(plastidj, plastidjprops[plastidj$tip.label, ], args.plotTree = list(show.node.label = T), args.barplot = list(col = colors, main = "Species Assignment", border = NA), arg.axis = list(axes = FALSE), legend.text = T, add = T)
dev.off()
