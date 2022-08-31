#!/bin/bash 

# get sample names for all files to be processed
Samps=$(find Results/SNP/ -name "*.g.vcf" | sed 's/.*/-V &/' | tr "\n" " ")

# Create DB of sample SNPs
if [ ! -d "arundinaria" ]; then
    gatk GenomicsDBImport "$Samps" \
        --genomicsdb-workspace-path arundinaria \
        -L matK -L psaA -L trnL -L WXY -L LFY
fi

# Genotype them all
gatk GenotypeGVCFs \
    -R References/references.fasta \
    -V gendb://arundinaria \
    -G StandardAnnotation \
    -O Results/SNP/Joint.vcf

