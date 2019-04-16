library(phytools)
#LFY <- read.nexus("LFY/HKYI/LFYrenamed.nex.con.tre") #doesnt work with nexus trees?
LFY <- read.tree("LFY/test/LFY_renamed_MrBayes_collapsed.newick") #import prerooted tree
LFY$tip.label <- gsub(pattern = "LFY", replacement = "LFY_",LFY$tip.label) #reinsert _ into name

#read in list of percents
LFYprops <- read.csv("rename.csv", header = T)[27:119,c(1,8:12)]
row.names(LFYprops) <- LFYprops[,1]
LFYprops <- LFYprops[,-1]
LFYprops <- LFYprops[order(row.names(LFYprops),LFY$tip.label),]

#Plot it
pdf("LFY.pdf", height=20, width=10)
#plot(LFY)
plotTree.barplot(LFY, LFYprops, args.plotTree = list(show.node.label=T) ,args.barplot = list(col=c("red","green","pink","blue","grey"), main="Species Assignment"), legend.text=T)
dev.off()

