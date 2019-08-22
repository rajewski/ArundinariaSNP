This repo contains the steps I used to process FASTQ files from Illumina 2x150bp sequencing of pooled PCR products for phylogenetic analysis. Each demultiplexed pool corresponds to a single individual, but the pool contains reads from 3-5 PCR-amplified loci. These loci are not homologous and their reads should easily assemble into separate contigs. Because the loci are also comparatively short (<1200bp), the read lengths *should* be long enough to phase haplotypes for each locus. 

Two notes on this phasing:
* Proper phasing requires that SNPs are frequent enough for a single read to span at least two SNPs. In some cases this is not possible and only certain regions of the loci can be phased. This causes "phased" sequences with IUPAC ambiguity codes. This problem would still exist with Sanger sequencing though.

* Even in cases where each locus can properly be phased, there is no correspondence between the first phased copy of one locus and the first phased copy of another locus. That is, we cannot prove that which of these copies is maternal and which is paternal across loci. Therefore concatenation of loci for phylogenetic analysis is impossible.

Each script used for processing is numbered in sequential order, and as of right now, the raw data files are also included in this repo, so the entire analysis should remain completely reproducible for the foreseeable future.

Scripts:

1. `1_indiv_variants.sh` is designed to run as an array job on a cluster computer such that each array job number corresponds to an individual sample to be analyzed. Array job numbers are matched to FASTQ files from the `names.txt` file via the `$Sample` and `$Indiv` variables in the script. Speedseq is used to align the reads, and it needs a `speedseq.config` file to properly run. This config file mostly tells the program where to find other programs for alignment. Read groups are also assigned in this step. This becomes terribly important later, so don't ignore it.

2. `2_combine.sh` takes the individual g.vcf files for each sample and combines them into a single `Joint.vcf` file, recalling variants in the entire cohort.

3. `3_phase.sh` uses WhatsHap to phase the samples in the `Joint.vcf` file. This requires Python 3, which I don't understand well. Likely this could be streamlined, but it works. Sorry. It will output a single Phased.vcf file, which might be enough for you, but it wasn't for me. so I had to continue

4. `4_split_phased.sh` iterates through Phased.vcf file and produces a single vcf file for each sample.

5. `5_CombinePhaseAmbig.R` switches into R. It takes the vcf information for each sample/locus and substitutes the SNPs for that sample in a reference sequence. This step ignores indels because alignment around them is sort of a bear. (Ignoring indels is not a minor thing. I could get much more phylogenetic information by including them, but I could also introduce larger systematic errors, which I felt was a bigger danger.) This script will output the following things:

 * a FASTA file for each locus with all of the haplotypes phased (e.g. `WXY_Phased.fasta`). This information can be used however you like it for phylogenetic analysis. Each haplotype for an individual is suffixed with _0 or _1, but remember that there is no correspondence between these numbers between samples or between loci. That is the _0 haplotype is not consistently the paternal haplotype in all samples.

 * a FASTA file for each locus with a single ambiguous sequence for each individual (e.g. `WXY_ambig.fasta`). This file can be used directly for a concatenated analysis.

 * for the nuclear loci only (_WXY_ and _LFY_), a FASTA file is output with the two ambiguous sequences for each individual concatenated into a single sequence (e.g. `Nuclear_ambig.fasta`). A similar concatenation is NOT done with the plastid loci included because in my case, some of my plastid loci were sanger sequenced, and this introduces a missing data problem and an indel problem. Because of this a concatenated FASTA of all loci would have several loci missing for most of the samples.

6. `phylo/6a_MrBayes.sh` is my standard script to run a Bayesian analysis of the alignments. It references a parameter file, several of which are included in the `MrBayesPars/` directory. This parameter file tells MrBayes what sort of analysis to run and on which alignment to run. MrBayes takes a NEXUS file as input, so I used another tool (not included) to convert the FASTA file from step 5 into a NEXUS file and to add in the samples that were Sanger sequenced. You can change this script to point to other parameter files in order to modify your analysis. For haplotype-phased samples, I have to run this script for each locus individually because concatenation of the phased samples across loci is impossible. With ambiguous samples, I can concantenate them.

7. `phylo/6b_RAxML.sh` is an atlernative to steps 6 with a maximum likelihood analysis. It's dealer's choice which you think is better but I ran both just to compare. (spoiler alert: with good phylogentic signal, it doesn't matter which you use). This script does not reference a parameter files so everything is hard coded in the call for raxml. The Exelixis lab released a new version of RAxML (RAxML-NG) during my analysis, so I switched over, but kept the older code and just commented it out.

8. `phylo/7a_ArundinariaCoords.R` will likely be totally worthless for you. It scrapes text from a publication that has GPS coordinates of the samples from other publications, and outputs them to a csv file.

9. `phylo/7b_PhyloMap.R` will maybe be more generally useful if you use your own data. It takes the coordinate information scraped in step 8 and some trees generates in steps 6 and 7 to make figures where tips of a phylogeny are connected to GPS points on a map. This is sort of a qualitative way to look for geographic signal in the analysis.

10. `phylo/7c_BarchartPhylo.R` is an exploratory analysis to plot a phylogeny alongside a stacked barchart. I had planned to see if this was a better way to display the grouping of haplotypes by species. It is mostly just messy.

11. `phylo/7d_clustering.sh` uses the module plink to perform a PCA and MDS of the data. The data here has been subset from the Phased.vcf to just include the two nuclear loci (LFY and WXY), so the code to do that is included in the beginning of that script. A related script `phylo/7e_PlotCluster.R` takes the data and makes a nicer looking plot of it.

12. `phylo/7e_Cophlyo.R` uses the R package phytools to plot two face-to-face phylogenies and connect identical tips. This allows you to see how the structure changes with the removal of certain tips. The rotation of the tips to minimize crossing of connectors is rather computationally intensive, so you can often do it by hand faster. I made a submission script to do this rotation as a non-interactive job (`phylo/7f_submit.sh`) and another script to actually plot the results of this (`phylo/7g_PlotCophylo.R`). Regardless, the results were not stunning, so I haven't prettied up this script like I would if I intended to use the analysis.

13. Because the phylogenetic analysis was rather fruitless, I switched to SplitsNetworks, as implemented by [SplitsTree4](http://www.splitstree.org/). `phylo/7h_SplitsNetwork.R` takes the nexus file output of SplitsTree. This nexus file is generated by reading an alignment (e.g. `Nuclear_ambig.fasta`) into SplitsTree, calculating a distance matrix with the uncorrected_p method averaging ambiguous sites, and exporting it. The script plots this network and colors the tips of the network by species assignment. Although the alignment includes NCBI reference sequences and an outgroup, these are filtered out to make the plot prettier. (The NCBI references also lack the _LFY_ locus and SplitsTree is bad with missing data.)

14. The SplitsTree distance matrix can also be used for a MDS analysis, similar to the one done with Plink in `phylo/7d_clustering.sh`. The MDS output by `phylo/7i_SplitsTreeMDS.R` is different, and I cannot yet parse out why/how. Theoretically, the MDS by Plink is operating on a VCF and _could_ incorporate information on haplotype phases and indels, which are explicitly ignored by the alignment that is read into SplitsTree. Additionally, Plink using raw Hamming distances to make its distance matrix for the MDS, wherease SplitsTree using uncorrected_p.


