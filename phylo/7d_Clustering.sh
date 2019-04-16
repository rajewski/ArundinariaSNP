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
module load plink/1.90b3.38

#Do a PCA
plink --allow-extra-chr --threads $SLURM_NTASKS --memory $SLURM_MEM_PER_NODE --vcf ../../Phased.vcf --pca -mind 0.5

plink --allow-extra-chr --threads $SLURM_NTASKS --memory $SLURM_MEM_PER_NODE --vcf ../../Phased.vcf --mds-plot 2 -mind 0.5 --cluster
