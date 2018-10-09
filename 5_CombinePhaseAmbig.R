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
g.ambig <- do.call(cbind, replicate(n=2, g.ambig, simplify = FALSE))
g.ambig <- g.ambig[,order(colnames(g.ambig))]
colnames(g.ambig) <- colnames(hapsNA)

#make table of ambiguous sites + phased SNPs
g.both <- ifelse(is.na(hapsNA),g.ambig,hapsNA)
g.both <- toupper(g.both) #make them uppercase bc...OCD

# Add these SNPs into the ref sequences
source("https://bioconductor.org/biocLite.R")
biocLite("Biostrings")
library(Biostrings)
refs <- readDNAStringSet("references.fasta")
# make a list to filter out samples we didnt sequence later
samples <- read.csv("sampleNames.txt",header=TRUE, sep="\t")[,1:2]
samples <- paste0(samples$X.target,"_",samples$sample)

# Write WXY Loci
WXYs <- rep(refs[1], 148)
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

# Write LFY Loci
LFYs <- rep(refs[2], 148)
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

# Write matK Loci
matKs <- rep(refs[3], 148)
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

# Write the trnL loci
trnLs <- rep(refs[5], 148)
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

