#!/bin/bash -l
#SBATCH --ntasks=1
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
else
    echo $(date): "Found PhasedNuclear.vcf. Dope."
fi

#load the module for making a PCA or MDS plot from a VCF
module load plink/1.90b3.38

#Do a PCA
if [ ! -e './Nuclear.eigenvec' ]; then
    echo $(date): "Running PCA"
    plink --allow-extra-chr --vcf ../results/PhasedNuclear.vcf --pca -mind 0.5 --out Nuclear
    echo $(date): "Done"
else
    echo $(date): "PCA results found. Dope."
fi

if [ ! -e './Nuclear.mds' ]; then
    echo $(date): "Running MDS"
    plink --allow-extra-chr --vcf ../results/PhasedNuclear.vcf --mds-plot 2 -mind 0.5 --cluster --out Nuclear
    echo $(date): "Done"
else
    echo $(date): "MDS results found. Dope."
fi

#Try using fastSTRUCUTRE on this dataset. It hella violates the assumptions, but it's just a test

#convert the vcf to structure input format
if [ ! -e '../results/PhasedNuclear.bed' ]; then
    echo $(date): "Recording VCF to structure format with plink."
    plink --allow-extra-chr --vcf ../results/PhasedNuclear.vcf --make-bed --out ../results/PhasedNuclear
    echo $(date): "Done"
else
    echo $(date: "proper input files detected."
fi

module load  faststructure/1.0_e47212f
structure.py -K 2 --input=../results/PhasedNuclear --output=../results/PhasedNuclearSTRUCTURE
structure.py -K 3 --input=../results/PhasedNuclear --output=../results/PhasedNuclearSTRUCTURE
structure.py -K 4 --input=../results/PhasedNuclear --output=../results/PhasedNuclearSTRUCTURE
structure.py -K 5 --input=../results/PhasedNuclear --output=../results/PhasedNuclearSTRUCTURE
structure.py -K 6 --input=../results/PhasedNuclear --output=../results/PhasedNuclearSTRUCTURE
