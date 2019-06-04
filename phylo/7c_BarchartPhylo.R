library(phytools)
#LFY <- read.nexus("LFY/HKYI/LFYrenamed.nex.con.tre") #doesnt work with nexus trees?
LFY <- read.tree("~/bigdata/Arundinaria/phylo/LFY/test/LFY_renamed_MrBayes_collapsed.newick") #import prerooted tree
LFY$tip.label <- gsub(pattern = "LFY", replacement = "LFY_",LFY$tip.label) #reinsert _ into name

#read in list of percents
LFYprops <- read.csv("rename.csv", header = T)[27:119,c(1,8:12)]
row.names(LFYprops) <- LFYprops[,1]
LFYprops <- LFYprops[,-1]
LFYprops <- LFYprops[order(match(row.names(LFYprops),LFY$tip.label)),]

#Plot it
colors<-setNames(c("red","green", "pink", "blue", "grey"),c("pApp","pGig", "pHyb", "pTec", "pUnk"))
#setwd("~/bigdata/Arundinaria/phylo/LFY/HKYI")
pdf("~/bigdata/Arundinaria/phylo/LFY/HKYI//LFY.pdf", height=20, width=10)
#plot(LFY)
  plotTree.barplot(LFY, LFYprops[LFY$tip.label,], args.plotTree = list(show.node.label=T), args.barplot = list(col=colors, main="Species Assignment", border=NA), arg.axis = list(axes=FALSE), legend.text=T)
  legend(x="topright",legend=names(colors), pch=22, pt.cex=2, pt.bg=colors, ncol=3, box.col="transparent")
dev.off()

#repeat for WXY
WXY <- read.tree("~/bigdata/Arundinaria/phylo/WXY/GTRGI/WXY_renamed_MrBayes_collapsed.newick") #import prerooted tree
WXY$tip.label <- gsub(pattern = "WXY", replacement = "WXY_",WXY$tip.label) #reinsert _ into name

#read in list of percents
WXYprops <- read.csv("~/bigdata/Arundinaria/phylo/rename.csv", header = T)[120:147,c(1,8:12)]
row.names(WXYprops) <- WXYprops[,1]
WXYprops <- WXYprops[,-1]
WXYprops <- WXYprops[order(match(row.names(WXYprops),WXY$tip.label)),]

#Plot it
pdf("~/bigdata/Arundinaria/phylo/WXY/GTRGI/WXY.pdf", height=20, width=10)
#plot(WXY)
  plotTree.barplot(WXY, WXYprops[WXY$tip.label,], args.plotTree = list(show.node.label=T), args.barplot = list(col=colors, main="Species Assignment", border=NA), arg.axis = list(axes=FALSE), legend.text=T)
  legend(x="topright",legend=names(colors), pch=22, pt.cex=2, pt.bg=colors, ncol=3, box.col="transparent")
dev.off()

#repeat for plasitd
plastid <- read.tree("~/bigdata/Arundinaria/phylo/plastid/F81I/Plastid_MrBayes_Collapsed") #import prerooted tree

#read in list of percents
plastidprops <- read.csv("~/bigdata/Arundinaria/phylo/rename.csv", header = T)[1:26,c(1,8:12)]
row.names(plastidprops) <- plastidprops[,1]
plastidprops <- plastidprops[,-1]
plastidprops <- plastidprops[order(match(row.names(plastidprops),plastid$tip.label)),]

#Plot it
pdf("~/bigdata/Arundinaria/phylo/plastid/F81I/plastid.pdf", height=20, width=10)
#plot(plastid)
  plotTree.barplot(plastid, plastidprops[plastid$tip.label,], args.plotTree = list(show.node.label=T), args.barplot = list(col=colors, main="Species Assignment", border=NA), arg.axis = list(axes=FALSE), legend.text=T)
  legend(x="topright",legend=names(colors), pch=22, pt.cex=2, pt.bg=colors, ncol=3, box.col="transparent")
dev.off()


