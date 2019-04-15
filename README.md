This repo contains the steps I used to process FASTQ files from Illumina 2x150bp sequencing of pooled PCR products for phylogenetic analysis. Each demultiplexed pool corresponds to a single individual, but the pool contains reads from 3-5 PCR-amplified loci. These loci are not homologous and their reads should easily assemble into separate contigs. Because the loci are also comparatively short (<1200bp), the read lengths *should* be long enough to phase haplotypes for each locus. 

Two notes on this phasing:
* Proper phasing requires that SNPs are frequent enough for a single read to span at least two SNPs. In some cases this is not possible and only certain regions of the loci can be phased. This causes "phased" sequences with IUPAC ambiguity codes. This problem would still exist with Sanger sequencing though.

* Even in cases where each locus can properly be phased, there is no correspondence between the first phased copy of one locus and the first phased copy of another locus. That is, we cannot prove that which of these copies is maternal and which is paternal across loci. Therefore concatenation of loci for phylogenetic analysis is impossible.

Each script used for processing is numbered in sequential order, and as of right now, the raw data files are also included in this repo, so the entire analysis should remain completely reproducible for the foreseeable future.

Scripts:

1. 1_indiv_variants.sh is designed to run as an array job on a cluster computer such that each array job number corresponds to an individual sample to be analyzed. Array job numbers are matched to FASTQ files from the names.txt file via the $Sample and $Indiv variables in the script. Speedseq is used to align the reads, and it needs a speedseq.config file to properly run. This config file mostly tells the program where to find other programs for alignment. Read groups are also assigned in this step. This becomes terribly important later, so don't ignore it.

2. 2_combine.sh takes the individual g.vcf files for each sample and combines them into a single Joint.vcf file, recalling variants in the entire cohort.

3. 3_phase.sh uses WhatsHap to phase the samples in the Joint.vcf file. This requires Python 3, which I don't understand well. Likely this could be streamlined, but it works. Sorry. It will output a single Phased.vcf file, which might be enough for you, but it wasn't for me. so I had to continue

4. 4_split_phased.sh iterates through Phased.vcf file and produces a single vcf file for each sample.

5. 5_CombinePhaseAmbig.R switches into R. It takes the vcf information for each sample/locus and substitutes the SNPs for that sample in a reference sequence. This step ignores indels because alignment around them is sort of a bear. (Ignoring indels is not a minor thing. I could get much more phylogenetic information by including them, but I could also introduce larger systematic errors, which I felt was a bigger danger.) This script will output a separate FASTA file for each locus with all of the phased samples. This information can be used however you like it for phylogenetic analysis.

6. phylo/6a_MrBayes.sh is my standard script to run a Bayesian analysis of the alignments. It references a parameter file (currently Plastid_NoMissing.par), which is also included in this directory. This parameter file tells MrBayes what sort of analysis to run and on which alignment to run. It takes a NEXUS file as input, so I used another tool (not included) to convert the FASTA file from step 5 into a NEXUS file. You can change this script to point to other parameter files in order to modify your analysis. I have to run this script for each locus because concatenation of the phased samples across loci is impossible.

7. phylo/6b_RAxML.sh is an atlernative to steps 6 with a maximum likelihood analysis. It's dealer's choice which you think is better but I ran both just to compare. (spoiler alert: with good phylogentic signal, it doesn't matter which you use). This script does not reference a parameter files so everything is hard coded in the call for raxml. Importantly this script requires the sequences to be in PHYLIP format, so I used another tool (not included) to convert the FASTA file from step 5 into a .phy file. I also have to run this script for each locus because concatenation of the phased samples across loci is impossible.

8. phylo/7a_ArundinariaCoords.R will likely be totally worthless for you. It scrapes text from a publication that has GPS coordinates of the samples from other publications, and outputs them to a csv file.

9. phylo/7b_PhyloMap.R will maybe be more generally useful if you use your own data. It takes the coordinate information scraped in step 8 and some trees generates in steps 6 and 7 to make figures where tips of a phylogeny are connected to GPS points on a map. This is sort of a qualitative way to look for geographic signal in the analysis.
