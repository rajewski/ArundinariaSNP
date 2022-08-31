#!/bin/bash

# Merge individual BAM files
if [ ! -e Results/BAM/merged.bam ]; then
  samtools merge Results/BAM/Merged.filtered.bam Results/BAM/*.bam
fi

# Index the merged BAM
samtools index Results/BAM/Merged.bam

# Phase the indidivual samples in the merged VCF
whatshap phase \
  --indels \
  --max-coverage 20 \
  -o Results/SNP/Phased.vcf \
  Results/SNP/Joint.vcf \
  Results/BAM/Merged.bam
