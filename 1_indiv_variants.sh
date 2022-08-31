#!/bin/bash 

# Make the indices of the references files
if [ ! -f "References/references.ann" ]; then
    bwa index -p References/references References/references.fasta
fi

if [ ! -f "References/references.fasta.fai" ]; then
    module load samtools/1.8
    samtools faidx References/references.fasta
fi

if [ ! -f "References/references.dict" ]; then
    picard CreateSequenceDictionary R=References/references.fasta O=References/references.dict
fi

# Loop over the Accession2Sample.tsv file, mapping each set of FASTQs and calling variants
source activate speedseq
while read accession sample; do
    # Skip if already present
    if [ ! -e Results/$sample ]; then
        # Map
        speedseq align \
            -t $SLURM_NTASKS \
            -o Results/BAM/$sample \
            -R '@RG\tID:'$sample'\tSM:'$sample'\tLB:Lib\' \
            References/references.fasta \
            FASTQ/$accession"_1.fastq.gz" \
            FASTQ/$accession"_2.fastq.gz"
    fi
    # Skip if already present
    if [ ! -e Results/SNP/$sample.g.vcf ]; then
        # Genotype
        gatk HaplotypeCaller \
            -R References/references.fasta \
            -I Results/BAM/$sample.bam \
            -O Results/SNP/$sample.g.vcf \
            -ERC GVCF
    fi
done < References/Accession2Sample.tsv
