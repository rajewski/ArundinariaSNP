#!/bin/bash 

# Made with help from https://www.biostars.org/p/78929/ (Rotten link)

for file in Results/SNP/Phased.vcf.gz; do
  for sample in $(bcftools query -l $file) ; do
    bcftools view -c1 -Oz -s "$sample" -o ${file/.vcf*/.$sample.vcf.gz} $file
  done
done
