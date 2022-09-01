#!/bin/bash

# Get vars for running commands
source 0_Paths.env

# Merge individual BAM files
if [ ! -e "${path_results_docker}/BAM/Merged.bam" ]; then
  ${_samtools[@]} merge "${path_results_docker}/BAM/Merged.bam" "${path_results_docker}/BAM/*.bam"
fi

# Index the merged BAM
${_samtools[@]} index "${path_results_docker}/BAM/Merged.bam"

# Phase the indidivual samples in the merged VCF
${_whatshap[@]} phase \
  --indels \
  --max-coverage 20 \
  -o "${path_results_docker}/SNP/Phased.vcf" \
  "${path_results_docker}/SNP/Joint.g.vcf"\
  "${path_results_docker}/BAM/Merged.bam"
