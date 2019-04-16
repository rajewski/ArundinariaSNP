#!/bin/bash -l
#SBATCH --ntasks=16
#SBATCH --nodes=1
#SBATCH --mem=400G
#SBATCH --time=20:00:00
#SBATCH --mail-user=araje002@ucr.edu
#SBATCH --mail-type=ALL
#SBATCH -p batch
#SBATCH -o ../history/slurm-%A.out
set -euv

# $((SLURM_MEM_PER_NODE/1000))'G'
# $SLURM_NTASKS

#load the module for making a PCA or MDS plot from a VCF
module load plink

plink --allow-extra-chr --vcf test_snps1.vcf --pca -mind 0.5

plink --allow-extra-chr --vcf test_snps1.vcf --mds-plot 2 -mind 0.5 --cluster
