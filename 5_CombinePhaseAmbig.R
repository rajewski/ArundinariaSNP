setwd("~/bigdata/Arundinaria/results")
library(vcfR)
g <- read.vcfR("Phased.vcf")
g.SNP <- extract.indels(g, return.indels = FALSE) # remove all indels to only deal with SNPs
g.SNP[,-c(75,76,89,90)] # Remove null samples
g.ambig <- alleles2consensus(extract.gt(g.SNP, return.alleles=TRUE), NA_to_n = FALSE) # make a table of IUPAC ambiguous bases for all heterozygotes
g.InDel <- extract.indels(g, return.indels = TRUE) # remove all SNPs, unused right now, but maybe later

hapsNA <- extract.haps(g.SNP) # Make table of only the phased variants, with unphased as NA
# extract.gt(g.SNP)
# hapsnoNA <- extract.haps(g.SNP, unphased_as_NA = FALSE)
# write.csv(hapsNA, file="HaplotypesNA.csv")
# write.csv(hapsnoNA, file="HaplotypesNoNa.csv")

#manipulate g.ambig table into same format as others to make lookups easier 
g.ambig.save <- g.ambig
g.ambig <- do.call(cbind, replicate(n=2, g.ambig, simplify = FALSE))
g.ambig <- g.ambig[,order(colnames(g.ambig))]
colnames(g.ambig) <- colnames(hapsNA)

#make table of ambiguous sites + phased SNPs
g.both <- ifelse(is.na(hapsNA),g.ambig,hapsNA)
g.both <- toupper(g.both) #make them uppercase bc...OCD

# Add these SNPs into the ref sequences
# source("https://bioconductor.org/biocLite.R")
# biocLite("Biostrings")
library(Biostrings)
refs <- readDNAStringSet("../references.fasta")
# make a list to filter out samples we didnt sequence later
samples <- read.csv("../sampleNames.txt",header=TRUE, sep="\t")[,1:2]
samples <- paste0(samples$X.target,"_",samples$sample)

# Write WXY Loci
WXYs <- rep(refs["WXY"], 148)
names(WXYs) <- paste0("WXY_", colnames(g.both))
WXYSNPs <- t(g.both[grep('^WXY', rownames(g.both)),])
colnames(WXYSNPs) <- gsub("WXY_","", colnames(WXYSNPs))
for (i in 1:148) {
  pos <- WXYSNPs[i,!is.na(WXYSNPs[i,])]
  WXYs[[i]] <- replaceLetterAt(WXYs[[i]], 1:length(WXYs[[1]]) %in% as.numeric(names(pos)), as.character(WXYSNPs[i,names(pos)]))
}
wxysamples <- c(paste0(samples[grep('^WXY',samples)],"_0"),paste0(samples[grep('^WXY',samples)],"_1"))
wxysamples <- wxysamples[order(wxysamples)]
WXYs <- WXYs[names(WXYs)[names(WXYs) %in% wxysamples]]
writeXStringSet(WXYs,"WXY_Phased.fasta")

# Write ambiguous WXY Loci
WXYsa <- rep(refs["WXY"], 74)
names(WXYsa) <- paste0("WXY_", colnames(g.ambig.save))
WXYSNPsa <- t(g.ambig.save[grep('^WXY', rownames(g.ambig.save)),])
colnames(WXYSNPsa) <- gsub("WXY_","", colnames(WXYSNPsa))
for (i in 1:74) {
  pos <- WXYSNPsa[i,!is.na(WXYSNPsa[i,])]
  WXYsa[[i]] <- replaceLetterAt(WXYsa[[i]], 1:length(WXYsa[[1]]) %in% as.numeric(names(pos)), as.character(WXYSNPsa[i,names(pos)]))
}
wxysamplesa <- c(samples[grep('^WXY',samples)])
wxysamplesa <- wxysamplesa[order(wxysamplesa)]
WXYsa <- WXYsa[names(WXYsa)[names(WXYsa) %in% wxysamplesa]]
writeXStringSet(WXYsa,"WXY_ambig.fasta")

# Write LFY Loci
LFYs <- rep(refs["LFY"], 148)
names(LFYs) <- paste0("LFY_", colnames(g.both))
LFYSNPs <- t(g.both[grep('^LFY', rownames(g.both)),])
LFYSNPs[95:96, 41] <- "G" #Manual correction of error, sorry
LFYSNPs[95:96, 42] <- "A" #Manual correction of error, sorry
colnames(LFYSNPs) <- gsub("LFY_","", colnames(LFYSNPs))
for (i in 1:148) {
  pos <- LFYSNPs[i,!is.na(LFYSNPs[i,])]
  LFYs[[i]] <- replaceLetterAt(LFYs[[i]], 1:length(LFYs[[1]]) %in% as.numeric(names(pos)), as.character(LFYSNPs[i,names(pos)]))
}
lfysamples <- c(paste0(samples[grep('^LFY',samples)],"_0"),paste0(samples[grep('^LFY',samples)],"_1"))
lfysamples <- lfysamples[order(lfysamples)]
LFYs <- LFYs[names(LFYs)[names(LFYs) %in% lfysamples]]
writeXStringSet(LFYs,"LFY_Phased.fasta")

# Write ambiguous LFY Loci
LFYsa <- rep(refs["LFY"], 74)
names(LFYsa) <- paste0("LFY_", colnames(g.ambig.save))
LFYSNPsa <- t(g.ambig.save[grep('^LFY', rownames(g.ambig.save)),])
LFYSNPsa[48, 41] <- "G" #Manual correction of error, sorry
LFYSNPsa[48, 42] <- "A" #Manual correction of error, sorry
colnames(LFYSNPsa) <- gsub("LFY_","", colnames(LFYSNPsa))
for (i in 1:74) {
  pos <- LFYSNPsa[i,!is.na(LFYSNPsa[i,])]
  LFYsa[[i]] <- replaceLetterAt(LFYsa[[i]], 1:length(LFYsa[[1]]) %in% as.numeric(names(pos)), as.character(LFYSNPsa[i,names(pos)]))
}
lfysamplesa <- c(samples[grep('^LFY',samples)])
lfysamplesa <- lfysamplesa[order(lfysamplesa)]
LFYsa <- LFYsa[names(LFYsa)[names(LFYsa) %in% lfysamplesa]]
writeXStringSet(LFYsa,"LFY_ambig.fasta")

# Write matK Loci
matKs <- rep(refs["matK"], 148)
names(matKs) <- paste0("matK_", colnames(g.both))
matKSNPs <- t(g.both[grep('^matK', rownames(g.both)),])
colnames(matKSNPs) <- gsub("matK_","", colnames(matKSNPs))
for (i in 1:148) {
  pos <- matKSNPs[i,!is.na(matKSNPs[i,])]
  matKs[[i]] <- replaceLetterAt(matKs[[i]], 1:length(matKs[[1]]) %in% as.numeric(names(pos)), as.character(matKSNPs[i,names(pos)]))
}
matksamples <- c(paste0(samples[grep('^matK',samples)],"_0"),paste0(samples[grep('^matK',samples)],"_1"))
matksamples <- matksamples[order(matksamples)]
matKs <- matKs[names(matKs)[names(matKs) %in% matksamples]]
writeXStringSet(matKs,"matK_Phased.fasta")

# Write ambiguous matK Loci
matKsa <- rep(refs["matK"], 74)
names(matKsa) <- paste0("matK_", colnames(g.ambig.save))
matKSNPsa <- t(g.ambig.save[grep('^matK', rownames(g.ambig.save)),])
colnames(matKSNPsa) <- gsub("matK_","", colnames(matKSNPsa))
for (i in 1:74) {
  pos <- matKSNPsa[i,!is.na(matKSNPsa[i,])]
  matKsa[[i]] <- replaceLetterAt(matKsa[[i]], 1:length(matKsa[[1]]) %in% as.numeric(names(pos)), as.character(matKSNPsa[i,names(pos)]))
}
matksamplesa <- c(samples[grep('^matK',samples)])
matksamplesa <- matksamplesa[order(matksamplesa)]
matKsa <- matKsa[names(matKsa)[names(matKsa) %in% matksamplesa]]
writeXStringSet(matKsa,"matK_ambig.fasta")

# Write the trnL loci
trnLs <- rep(refs["trnL"], 148)
names(trnLs) <- paste0("trnL_", colnames(g.both))
trnLSNPs <- t(g.both[grep('^trnL', rownames(g.both)),])
colnames(trnLSNPs) <- gsub("trnL_","", colnames(trnLSNPs))
for (i in 1:148) {
  pos <- trnLSNPs[i,!is.na(trnLSNPs[i,])]
  trnLs[[i]] <- replaceLetterAt(trnLs[[i]], 1:length(trnLs[[1]]) %in% as.numeric(names(pos)), as.character(trnLSNPs[i,names(pos)]))
}
trnlsamples <- c(paste0(samples[grep('^trnL',samples)],"_0"),paste0(samples[grep('^trnL',samples)],"_1"))
trnlsamples <- trnlsamples[order(trnlsamples)]
trnLs <- trnLs[names(trnLs)[names(trnLs) %in% trnlsamples]]
writeXStringSet(trnLs,"trnL_Phased.fasta")

# Write the ambiguous trnL loci
trnLsa <- rep(refs["trnL"], 74)
names(trnLsa) <- paste0("trnL_", colnames(g.ambig.save))
trnLSNPsa <- t(g.ambig.save[grep('^trnL', rownames(g.ambig.save)),])
colnames(trnLSNPsa) <- gsub("trnL_","", colnames(trnLSNPsa))
for (i in 1:74) {
  pos <- trnLSNPsa[i,!is.na(trnLSNPsa[i,])]
  trnLsa[[i]] <- replaceLetterAt(trnLsa[[i]], 1:length(trnLsa[[1]]) %in% as.numeric(names(pos)), as.character(trnLSNPsa[i,names(pos)]))
}
trnlsamplesa <- c(samples[grep('^trnL',samples)])
trnlsamplesa <- trnlsamplesa[order(trnlsamplesa)]
trnLsa <- trnLsa[names(trnLsa)[names(trnLsa) %in% trnlsamplesa]]
writeXStringSet(trnLsa,"trnL_ambig.fasta")

# Write the psaA loci
psaAs <- rep(refs["psaA"], 148)
names(psaAs) <- paste0("psaA_", colnames(g.both))
psaASNPs <- t(g.both[grep('^psaA', rownames(g.both)),])
colnames(psaASNPs) <- gsub("psaA_","", colnames(psaASNPs))
for (i in 1:148) {
  pos <- psaASNPs[i,!is.na(psaASNPs[i,])]
  psaAs[[i]] <- replaceLetterAt(psaAs[[i]], 1:length(psaAs[[1]]) %in% as.numeric(names(pos)), as.character(psaASNPs[i,names(pos)]))
}
psaasamples <- c(paste0(samples[grep('^psaA',samples)],"_0"),paste0(samples[grep('^psaA',samples)],"_1"))
psaasamples <- psaasamples[order(psaasamples)]
psaAs <- psaAs[names(psaAs)[names(psaAs) %in% psaasamples]]
writeXStringSet(psaAs,"psaA_Phased.fasta")

# Write the ambiguous psaA loci
psaAsa <- rep(refs["psaA"], 74)
names(psaAsa) <- paste0("psaA_", colnames(g.ambig.save))
psaASNPsa <- t(g.ambig.save[grep('^psaA', rownames(g.ambig.save)),])
colnames(psaASNPsa) <- gsub("psaA_","", colnames(psaASNPsa))
for (i in 1:74) {
  pos <- psaASNPsa[i,!is.na(psaASNPsa[i,])]
  psaAsa[[i]] <- replaceLetterAt(psaAsa[[i]], 1:length(psaAsa[[1]]) %in% as.numeric(names(pos)), as.character(psaASNPsa[i,names(pos)]))
}
psaasamplesa <- c(samples[grep('^psaA',samples)])
psaasamplesa <- psaasamplesa[order(psaasamplesa)]
psaAsa <- psaAsa[names(psaAsa)[names(psaAsa) %in% psaasamplesa]]
writeXStringSet(psaAsa,"psaA_ambig.fasta")

# try to merge the ambiguious datasets into a single stringset since theyre in the same order
mergedsa <- xscat(LFYsa, WXYsa, matKsa, trnLsa, psaAsa)
names(mergedsa) <- colnames(g.ambig.save)
writeXStringSet(mergedsa,"Concatenated_ambig.fasta")






