#!/bin/bash 

# Get vars for running commands
source 0_Paths.env
source 0_Containers.env

# get sample names for all files to be processed
Samps=$(find "${path_results_local}/SNP" -name "*.g.vcf" \
    | sed 's/.*/-V &/' \
    | sed "s@${path_results_local}/@${path_results_docker}@g" \
    | tr "\n" " ")

# Create DB of sample SNPs
if [ ! -d "arundinaria" ]; then
    ${_gatk[@]} GenomicsDBImport "$Samps" \
        --genomicsdb-workspace-path arundinaria \
        -L matK -L psaA -L trnL -L WXY -L LFY
fi

# Genotype them all
${_gatk[@]} GenotypeGVCFs \
    -R "$path_ref_docker/references.fasta" \
    -V gendb://arundinaria \
    -G StandardAnnotation \
    -O "${path_results_docker}/SNP/Joint.g.vcf"

