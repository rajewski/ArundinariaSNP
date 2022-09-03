#!/usr/bin/env bash

# Get vars for running commands
source 0_Paths.env
source 0_Containers.env

#Make a VCF file with just the SNP calls from nuclear loci
if [ ! -e "${path_results_local}/SNP/PhasedNuclear.vcf" ]; then
    echo "$(date): Creating VCF of nuclear loci"
    touch "${path_results_local}/SNP/PhasedNuclear.vcf" 
    grep "#" "${path_results_local}/SNP/Phased.vcf" > "${path_results_local}/SNP/PhasedNuclear.vcf" 
    grep -v "#" "${path_results_local}/SNP/Phased.vcf" | grep "LFY" >> "${path_results_local}/SNP/PhasedNuclear.vcf"
    grep -v "#" "${path_results_local}/SNP/Phased.vcf" | grep "WXY" >> "${path_results_local}/SNP/PhasedNuclear.vcf"
    echo "$(date): Done"
else
    echo "$(date): Found PhasedNuclear.vcf. Dope."
fi

# make a handful of subset vcf files with only one sample per population (only necessary for Hull Rd)
if [ ! -e "${path_results_local}/SNP/PhasedNuclearH-2C.vcf" ]; then
    echo "$(date): subsetting the VCF to exclude all but H-2C or H8D from Hull"
    touch "${path_results_local}/SNP/PhasedNuclearH-2C.vcf"
    ${_bcftools[@]} view -s ^H-2D,H0B,H0C,H10B,H10C,H10D,H10E,H12D,H14C,H14D,H2A,H2B,H2C,H4A,H4B,H4C,H4D,H6A,H6B,H6C,H6D,H8A,H8B,H8C,H8D  "${path_results_local}/SNP/PhasedNuclear.vcf" > "${path_results_local}/SNP/PhasedNuclearH-2C.vcf"
    ${_bcftools[@]} view -s ^H-2C,H-2D,H0B,H0C,H10B,H10C,H10D,H10E,H12D,H14C,H14D,H2A,H2B,H2C,H4A,H4B,H4C,H4D,H6A,H6B,H6C,H6D,H8A,H8B,H8C "${path_results_local}/SNP/PhasedNuclear.vcf" > "${path_results_local}/SNP/PhasedNuclearH8D.vcf"
    echo "$(date): Done for H-2C and H8D"
else
    echo "$(date): VCF already subset"
fi

# Do a PCA
if [ ! -e "${path_results_local}/Clustering/Nuclear.eigenvec" ]; then
    echo "$(date): Running PCA"
    ${_plink[@]} --allow-extra-chr --vcf "${path_results_docker}/SNP/PhasedNuclear.vcf" --pca -mind 0.5 --out "${path_results_docker}/Clustering/Nuclear"
    ${_plink[@]} --allow-extra-chr --vcf "${path_results_docker}/SNP/PhasedNuclearH-2C.vcf" --pca -mind 0.5 --out "${path_results_docker}/Clustering/NuclearH-2C"
    ${_plink[@]} --allow-extra-chr --vcf "${path_results_docker}/SNP/PhasedNuclearH8D.vcf" --pca -mind 0.5 --out "${path_results_docker}/Clustering/NuclearH8D"
    echo "$(date): Done"
else
    echo "$(date): PCA results found. Dope."
fi

if [ ! -e "${path_results_local}/Clustering/Nuclear.mds" ]; then
    echo "$(date): Running MDS"
    ${_plink[@]} --allow-extra-chr --vcf "${path_results_docker}/SNP/PhasedNuclear.vcf" --mds-plot 2 -mind 0.5 --cluster --out "${path_results_docker}/Clustering/Nuclear"
    ${_plink[@]} --allow-extra-chr --vcf "${path_results_docker}/SNP/PhasedNuclearH-2C.vcf" --mds-plot 2 -mind 0.5 --cluster --out "${path_results_docker}/Clustering/NuclearH-2C"
    ${_plink[@]} --allow-extra-chr --vcf "${path_results_docker}/SNP/PhasedNuclearH8D.vcf" --mds-plot 2 -mind 0.5 --cluster --out "${path_results_docker}/Clustering/NuclearH8D"
    echo "$(date): Done"
else
    echo "$(date): MDS results found. Dope."
fi

# Try using fastSTRUCUTRE on this dataset. It hella violates the assumptions, but it's just a test

# convert the vcf to structure input format
if [ ! -e '../results/PhasedNuclear.bed' ]; then
    echo "$(date): Recording VCF to structure format with plink."
    ${_plink[@]} --allow-extra-chr --vcf "${path_results_docker}/SNP/PhasedNuclear.vcf" --make-bed --out "${path_results_docker}/Clustering/PhasedNuclear"
    echo "$(date): Done"
else
    echo "$(date): proper input files detected."
fi

${_faststructure[@]} structure.py -K 2 --input="${path_results_docker}/Clustering/PhasedNuclear" --output="${path_results_docker}/Clustering/PhasedNuclearSTRUCTURE"
${_faststructure[@]} structure.py -K 3 --input="${path_results_docker}/Clustering/PhasedNuclear" --output="${path_results_docker}/Clustering/PhasedNuclearSTRUCTURE"
${_faststructure[@]} structure.py -K 4 --input="${path_results_docker}/Clustering/PhasedNuclear" --output="${path_results_docker}/Clustering/PhasedNuclearSTRUCTURE"
${_faststructure[@]} structure.py -K 5 --input="${path_results_docker}/Clustering/PhasedNuclear" --output="${path_results_docker}/Clustering/PhasedNuclearSTRUCTURE"
${_faststructure[@]} structure.py -K 6 --input="${path_results_docker}/Clustering/PhasedNuclear" --output="${path_results_docker}/Clustering/PhasedNuclearSTRUCTURE"
