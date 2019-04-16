#!/bin/bash -l
#SBATCH --ntasks=6
#SBATCH --nodes=1
#SBATCH --mem=1G
#SBATCH --time=02:00:00
#SBATCH --mail-user=araje002@ucr.edu
#SBATCH --mail-type=ALL
#SBATCH -p batch
#SBATCH -o ../history/slurm-%A.out
set -euv

# $((SLURM_MEM_PER_NODE/1000))'G'
# $SLURM_NTASKS

#Make a VCF file with just the SNP calls from nuclear loci
if [ ! -e '../results/PhasedNuclear.vcf' ]; then
    echo $(date): "Creating VCF of nuclear loci"
    touch ../results/PhasedNuclear.vcf
    grep "#" ../results/Phased.vcf > ../results/PhasedNuclear.vcf
    grep -v "#" ../results/Phased.vcf | grep "LFY" >> ../results/PhasedNuclear.vcf
    grep -v "#" ../results/Phased.vcf | grep "WXY" >> ../results.PhasedNuclear.vcf
    echo $(date): "Done"
fi

#load the module for making a PCA or MDS plot from a VCF
module load plink/1.90b3.38

#Do a PCA
if [ ! -e './Nuclear.eigenvec' ]; then
    echo $(date): "Running PCA"
    plink --allow-extra-chr --threads $SLURM_NTASKS --memory $SLURM_MEM_PER_NODE --vcf ../results/PhasedNuclear.vcf --pca -mind 0.5 --out Nuclear
    echo $(date): "Done"
fi

if [ ! -e './Nuclear.mds' ; then
    echo $(date): "Running MDS"
    plink --allow-extra-chr --threads $SLURM_NTASKS --memory $SLURM_MEM_PER_NODE --vcf ../results/PhasedNuclear.vcf --mds-plot 2 -mind 0.5 --cluster --out Nuclear
    echo $(date): "Done"
fi
