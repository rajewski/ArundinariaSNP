#!/bin/bash

samtools merge Results/BAM/merged.filtered.bam
samtools index Results/BAM/merged.filtered.bam

whatshap phase \
  --indels \
  --max-coverage 20 \
  -o Results/SNP/Phased.vcf \
  Results/SNP/Joint.vcf \
  Results/BAM/merged.filtered.bam
