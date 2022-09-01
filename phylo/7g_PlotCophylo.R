setwd("~/bigdata/Arundinaria/phylo/")
library(phytools)
LFYAll <- read.nexus("LFY/HKYI/LFYrenamed.nex.con.rot.tre")
LFYJimmy <- read.nexus("LFY/HKYI/LFYrenamedJimmy.nex.con.rot.tre")
WXYAll <-read.nexus("WXY/SYMI/WXYrenamed.nex.con.rot.tre")
WXYJimmy <- read.nexus("WXY/SYMI/WXYrenamedJimmy.nex.con.rot.tre")
cpAll <- read.nexus("plastid/F81I/Plastid_NoMissingrenamed.nex.con.rot.tre")
cpJimmy <- read.nexus("plastid/F81I/Plastid_NoMissingrenamedJimmy.nex.con.rot.tre")

LFYcomp <- cophylo(LFYAll, LFYJimmy, rotate=F)
WXYcomp <- cophylo(WXYAll, WXYJimmy, rotate=F)
cpcomp  <- cophylo(cpAll, cpJimmy, rotate=F)

pdf(file="Single Locus Cophylo.pdf", height=30, width=10)
par(mfrow=c(3,1))
plot.cophylo(LFYcomp, fsize=0.5, offset=0.1, link.type="curved", link.lwd=3,link.lty="solid", 
             link.col=make.transparent("blue",0.2), lwd=3, pts=F, tip.len=0, ftype="off")
nodelabels.cophylo(round(as.numeric(LFYcomp$trees[[1]]$node.label[2:LFYcomp$trees[[1]]$Nnode]),2),1:LFYcomp$trees[[1]]$Nnode+
                    Ntip(LFYcomp$trees[[1]]),frame="none",cex=0.6, adj=c(-1.5,0))
nodelabels.cophylo(round(as.numeric(LFYcomp$trees[[2]]$node.label[2:LFYcomp$trees[[2]]$Nnode]),2),1:LFYcomp$trees[[1]]$Nnode+
                    Ntip(LFYcomp$trees[[2]]),frame="none",cex=0.6, adj=c(1.5,0), which="right")
plot.cophylo(WXYcomp, fsize=0.5, offset=0.1, link.type="curved", link.lwd=3,link.lty="solid", 
             link.col=make.transparent("blue",0.2), lwd=3, pts=F, tip.len=0, ftype="off")
nodelabels.cophylo(round(as.numeric(WXYcomp$trees[[1]]$node.label[2:WXYcomp$trees[[1]]$Nnode]),2),1:WXYcomp$trees[[1]]$Nnode+
                     Ntip(WXYcomp$trees[[1]]),frame="none",cex=0.6, adj=c(-1.5,0))
nodelabels.cophylo(round(as.numeric(WXYcomp$trees[[2]]$node.label[2:WXYcomp$trees[[2]]$Nnode]),2),1:WXYcomp$trees[[1]]$Nnode+
                     Ntip(WXYcomp$trees[[2]]),frame="none",cex=0.6, adj=c(1.5,0), which="right")
plot.cophylo(cpcomp, fsize=0.5, offset=0.1, link.type="curved", link.lwd=3,link.lty="solid", 
             link.col=make.transparent("blue",0.2), lwd=3, pts=F, tip.len=0, ftype="off")
nodelabels.cophylo(round(as.numeric(cpcomp$trees[[1]]$node.label[2:cpcomp$trees[[1]]$Nnode]),2),1:cpcomp$trees[[1]]$Nnode+
                     Ntip(cpcomp$trees[[1]]),frame="none",cex=0.6, adj=c(-1.5,0))
nodelabels.cophylo(round(as.numeric(cpcomp$trees[[2]]$node.label[2:cpcomp$trees[[2]]$Nnode]),2),1:cpcomp$trees[[1]]$Nnode+
                     Ntip(cpcomp$trees[[2]]),frame="none",cex=0.6, adj=c(1.5,0), which="right")
dev.off()


#Again but with collapsed trees, since I did the rotation by hand for LFY, it's a new file.
# all the others were rotated fine by default, they just needed to be rooted
LFYAllColl <- read.nexus("LFY/HKYI/LFYrenamed.nex.con.collapsed.rot.tre")
LFYJimmyColl <- read.nexus("LFY/HKYI/LFYrenamedJimmy.nex.con.collapsed.tre")
WXYAllColl <-read.nexus("WXY/SYMI/WXYrenamed.nex.con.collapsed.tre")
WXYAllColl <- root(WXYAllColl, outgroup="WXY_Pedulis", resolve.root=T)
WXYJimmyColl <- read.nexus("WXY/SYMI/WXYrenamedJimmy.nex.con.collapsed.tre")
WXYJimmyColl <- root(WXYJimmyColl, outgroup="WXY_Pedulis", resolve.root = T)
cpAllColl <- read.nexus("plastid/F81I/Plastid_NoMissingrenamed.nex.con.collapsed.tre")
cpAllColl <- root(cpAllColl, outgroup="cp_Pedulis", resolve.root = T)
cpJimmyColl <- read.nexus("plastid/F81I/Plastid_NoMissingrenamedJimmy.nex.con.collapsed.tre")
cpJimmyColl <- root(cpJimmyColl, outgroup="cp_Pedulis", resolve.root = T)

LFYcompColl <- cophylo(LFYAllColl, LFYJimmyColl, rotate=F)
WXYcompColl <- cophylo(WXYAllColl, WXYJimmyColl, rotate=F)
cpcompColl  <- cophylo(cpAllColl, cpJimmyColl, rotate=F)

pdf(file="Single Locus Collapsed Cophylo.pdf", height=30, width=10)
par(mfrow=c(3,1))
plot.cophylo(LFYcompColl, fsize=0.5, offset=0.1, link.type="curved", link.lwd=3,link.lty="solid", 
             link.col=make.transparent("blue",0.2), lwd=3, pts=F, tip.len=0, ftype="off")
nodelabels.cophylo(round(as.numeric(LFYcompColl$trees[[1]]$node.label[2:LFYcompColl$trees[[1]]$Nnode]),2),1:LFYcompColl$trees[[1]]$Nnode+
                     Ntip(LFYcompColl$trees[[1]]),frame="none",cex=0.6, adj=c(-1.5,0))
nodelabels.cophylo(round(as.numeric(LFYcompColl$trees[[2]]$node.label[2:LFYcompColl$trees[[2]]$Nnode]),2),1:LFYcompColl$trees[[1]]$Nnode+
                     Ntip(LFYcompColl$trees[[2]]),frame="none",cex=0.6, adj=c(1.5,0), which="right")
plot.cophylo(WXYcompColl, fsize=0.5, offset=0.1, link.type="curved", link.lwd=3,link.lty="solid", 
             link.col=make.transparent("blue",0.2), lwd=3, pts=F, tip.len=0, ftype="off")
nodelabels.cophylo(round(as.numeric(WXYcompColl$trees[[1]]$node.label[2:WXYcompColl$trees[[1]]$Nnode]),2),1:WXYcompColl$trees[[1]]$Nnode+
                     Ntip(WXYcompColl$trees[[1]]),frame="none",cex=0.6, adj=c(-1.5,0))
nodelabels.cophylo(round(as.numeric(WXYcompColl$trees[[2]]$node.label[2:WXYcompColl$trees[[2]]$Nnode]),2),1:WXYcompColl$trees[[1]]$Nnode+
                     Ntip(WXYcompColl$trees[[2]]),frame="none",cex=0.6, adj=c(1.5,0), which="right")
plot.cophylo(cpcompColl, fsize=0.5, offset=0.1, link.type="curved", link.lwd=3,link.lty="solid", 
             link.col=make.transparent("blue",0.2), lwd=3, pts=F, tip.len=0, ftype="off")
nodelabels.cophylo(round(as.numeric(cpcompColl$trees[[1]]$node.label[2:cpcompColl$trees[[1]]$Nnode]),2),1:cpcompColl$trees[[1]]$Nnode+
                     Ntip(cpcompColl$trees[[1]]),frame="none",cex=0.6, adj=c(-1.5,0))
nodelabels.cophylo(round(as.numeric(cpcompColl$trees[[2]]$node.label[2:cpcompColl$trees[[2]]$Nnode]),2),1:cpcompColl$trees[[1]]$Nnode+
                     Ntip(cpcompColl$trees[[2]]),frame="none",cex=0.6, adj=c(1.5,0), which="right")
dev.off()

