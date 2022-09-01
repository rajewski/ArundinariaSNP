#!/bin/bash 

# Get vars for running commands
source 0_Paths.env
source 0_Containers.env

# Made with help from https://www.biostars.org/p/78929/ (Rotten link)
# I think this script is broken, but I need real data to test it

for file in "${path_results_local}/SNP/Phased.vcf.gz"; do
  # convert local to docker path
  file=$(echo $file |sed "s@${path_results_local}/@${path_results_docker}@g")
  for sample in $(${_bcftools[@]} query -l ${path_results_local}/SNP/Phased.vcf.gz) ; do
    ${_bcftools[@]} view -c1 -Oz -s "$sample" -o ${file/.vcf*/.$sample.vcf.gz} $file
  done
done

