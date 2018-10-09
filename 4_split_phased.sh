#!/bin/bash -l
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --mem=1G
#SBATCH --time=2:00:00
#SBATCH --mail-user=araje002@ucr.edu
#SBATCH --mail-type=ALL
#SBATCH -p batch
#SBATCH -o ./history/slurm-%A_%a.out

module load bcftools/1.8

for file in results/Phased.vcf.gz; do
    for sample in `bcftools query -l $file`; do
	bcftools view -c1 -0z -s $sample -0 ${file/.vcf*/.$sample.vcf.gz} $file
    done
done
