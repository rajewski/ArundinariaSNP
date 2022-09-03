#!/bin/bash 

# Get vars for running commands
source 0_Paths.env
source 0_Containers.env

# Split the single phased VCF into once phased vcf per sample
# Need the input phased file name for substution later
for file in "${path_results_local}/SNP/Phased.vcf"; do
  file=$(echo $file |sed "s@${path_results_local}/@${path_results_docker}@g")
  for sample in $(${_bcftools[@]} query -l ${path_results_docker}/SNP/Phased.vcf) ; do
    ${_bcftools[@]} view -c1 -Oz -s "$sample" -o ${file/.vcf*/.$sample.vcf} $file
  done
done

