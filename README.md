# CRISPR Amplicon Genotyping

The purpose of these scripts is to process Illumina sequencing data for pools of PCR products. These PCR products correspond to genomic regions that *should* contain a CRISPR-induced mutation of some sort. 

## Multiplexing
This experiment assumes three levels of multiplexing.

- Individula PCR products from different genomic loci are pooled immediately after PCR assuming that the loci are different enough to be assembled unambiguously from short reads. In our case we are pooling up to 12 loci. Five loci across four tomato (*Solanum pimpinellifolium*) genes and seven additional loci across four orthologous genes in tobacco (*Nicotiana obtusifolia*). The regions of the orthologous genes being pooled are different, enabling this multiplexing despite the similarity.

- Using a series of 96 __inline__ barcodes 4-7 bp in length originally designed for RAD-seq, we are multiplexing the pools of 12 PCR products together.

- By adding on additional Illumina barcodes, we can combine several groups of 96 inline-barcoded PCR product pools. Currently we depend on our seqeuncing core to conduct this level of demultiplexing, but the scripts here could be modified to include it.

Currently we are not exploiting the full level of multiplexing, but I expect that a single MiSeq Nano run could produce data for several thousand loci if multiplex properly to avoid overlap.

## Wet Lab Procedures

I am working to write up a more detailed protocol on Protocols.io that would explain exactly how this sequencing library is constructed, but I will summarize it briefly here.

For every locus to be amplified, we have desinged a primer pair with three regions:
1. A locus specific sequence roughly 20bp in length that should bind to the genomic target.
2. For the forward primer, a 6bp PstI recognition and cut site. For the reverse primer, a 4bp MspI recognition and cut site.
   It is important that the amplicon between the primer pairs not contain cut sites for either enzyme engineered into the primers. Also, the selection of enzymes here has no significance other than that it enabled us to use pre-existing multiplexing barcodes that our lab was using for a separate ddRAD-seq experiment. If you have other RAD-seq barcodes, check to make sure then enzyme cute sites are compatible.
3. A 6 bp extension that better enables binding of the restriction enzyme. Without this extension, the enzyme is binding to the literal end of a DNA fragment and this can reduce efficiency.

The loci are amplified with the appropriate primer pairs using a cycle number that should give roughly equal PCR product concentrations across all primer pairs. In the case of lower multiplexing (<1000 loci per run), the concentrations can be off by up to 1 order of magnitute before it starts to affect a MiSeq run's output across loci. Assuming you are only using one Illumina barcode, all PCR products that are going to be given the same inline barcode are then pooled together and cleaned up with SPRI beads.

Each of the 96 groups (again assuming 96 inline barcodes and 1 Illumina barcode) are then individually digested with MspI and PstI, and the inliine barcodes are ligated on to the PCR products. These inline barcodes also contain a binding site for the Illumina barcodes. Following this, the Illumina barcodes, which contain the sequencing adaptors, are added via PCR. Because of stochasticity in PCR, each of the 96 groups is divided into 4 aliquots and the Illumina barcodes are added to each of these 384 aliquots separatetly and later pooled. A final SPRI bead clean up removes any inligated adaptors, PCR buffer, and enzymes. The library can then be sequenced.

## Data Processing

This git has 5 main scripts that generate the ultimate VCF output. This git also depends on a few external reference files in addition to the sequencing data.

### External Data

- Output from Illumina sequencer, demultiplexed by Illumina barcode. For paired-end sequencing with only one Illumina barcode, this would be two fastq files. (Litt_MiSeq_S1_R1_001.fastq.gz and /Litt_MiSeq_S1_R2_001.fastq.gz)
- A fasta file containing the reference sequences of the unmutated PCR products in order to align the short reads. (References.fasta)
- A tab delimited file containing the sequences of the 96 barcodes and a corresponding sample name. The sample name is arbitrary, but will be the basis for naming fastq, bam, and vcf files later, so make it meaningful. (1266_barcodes.txt)
- A separate file (although I suppose that I could streamline this) containing just the names of the samples for alignment (Names.txt)

### Scripts

- `1_SetUp.sh` downloads the Illumina output fastq files and creates the various necessary indicies for the References.fasta file.
- `2_Demultiplex.sh` quality and adaptor trims the Illumina fastq files. It then demultiplexes these two files into individual fastq files based on their inline barcodes. For paired-end data, this produces 4 files per inline barcode. The main files are {SampleName}.1.fq and {SampleName}.2.fq. Any read whose mate did not survive the demultiplexing (because of low quality, disrupted barcode, etc) is written to {SampleName}.1.rem.fq or {SampleName}.2.rem.fq.
- `3_Align.sh` uses [SpeedSeq](https://github.com/hall-lab/speedseq) to align the short reads to the references and produces 3 bam files for each of the 96 inline barcoded samples. This alignment ignores the unpaired reads because in practice, the coverage is so high that it doesn't make a difference. This script then uses GATK's Haplotype Caller to produce individual VCF files for each inline barcoded sample. This only uses the main bam file output by SpeedSeq.
- `4_JointGenotype.sh` follows [GATK's best practices](https://gatk.broadinstitute.org/hc/en-us/articles/360035535932-Germline-short-variant-discovery-SNPs-Indels-) to then do joint haplotype calling on the entire cohort of samples. I suspec that this does not produce dramatically improved results over individualy haplotype calling, but it is so quick that the opportunity cost is basically nothing. The main advantage is that is produces a single VCF for the entire cohort, which is much easier to wrangle, I think.
- `5_Phase.sh` then merges the individual bam files from `3_Align.sh` into a single bam file, indexes it, and attempts to use these reads to properly phase the individual haplotypes for each PCR producting using [WhatsHap](https://whatshap.readthedocs.io/en/latest/). This depends on two mutations being closer than the read length from your Illumina run. If successful, it will add phase information to the VCF so that you can tell which alleles within a locus are physcially linked. It is not 100% sucessful however.

### Visualization

The final Phased.vcf and References.fasta can be loaded into [IGV](http://igv.org) or [Geneious](https://www.geneious.com) in order to see mutations. At this point it is useful to know where exactly your gRNAs should bind in the References.fasta sequences. Some "mutations" may in fact be PCR or (much less ikely) sequencing errors, and you would expect those to occur randomly across the sequences rather than preferentially overlapping your gRNA.

## Notes

I am considering conducting this entire pipeline with SpeedSeq, but at the time that I designed it, GATK was a much more mature pipeline for haplotype calling.

