#!/usr/bin/env bash

# Get vars for running commands
source 0_Docker_Setup.sh

# Make the indices of the references files
if [ ! -f "References/references.ann" ]; then
    ${_bwa[@]} index -p "$path_ref_docker/references" "$path_ref_docker/references.fasta"
fi

if [ ! -f "References/references.fasta.fai" ]; then
    ${_samtools[@]} faidx "$path_ref_docker/references.fasta"
fi

if [ ! -f "References/references.dict" ]; then
    ${_gatk[@]} CreateSequenceDictionary -R "$path_ref_docker/references.fasta" -O "$path_ref_docker/references.dict"
fi

# Loop over the Accession2Sample.tsv file, mapping each set of FASTQs and calling variants
while read -r accession sample; do
    # Skip if already present
    if [ ! -e "${path_results_docker}/BAM/${sample}" ]; then
        # Map
        ${_speedseq[@]} align \
            -t "$SLURM_NTASKS" \
            -o "${path_results_docker}/BAM/${sample}" \
            -R '@RG\tID:'"$sample"'\tSM:'"$sample"'\tLB:Lib' \
            "$path_ref_docker/references.fasta" \
            "${path_fastq_docker}/${accession}_1.fastq.gz" \
            "${path_fastq_docker}/${accession}_2.fastq.gz" 
    fi
    # Skip if already present
    if [ ! -e "${path_results_docker}/SNP/${sample}.g.vcf" ]; then
        # Genotype
        ${_gatk[@]} HaplotypeCaller \
            -R "$path_ref_docker/references.fasta" \
            -I "${path_results_docker}/BAM/${sample}.bam" \
            -O "${path_results_docker}/SNP/${sample}.g.vcf" \
            -ERC GVCF
    fi
done < "${path_ref_local}/Accession2Sample.tsv"
