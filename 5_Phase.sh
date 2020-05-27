#!/bin/bash -l
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --mem=7G
#SBATCH --time=2:00:00
#SBATCH --mail-user=araje002@ucr.edu
#SBATCH --mail-type=ALL
#SBATCH -p short
#SBATCH -o ./history/Phase-%A_%a.out

# Get sample names
if [ ! -e results/Merged.bam.bai ]; then
    echo Merging and indexing BAM files...
    Bams=$(find results/ \( -name "*.bam" -not -name "*splitters*" -not -name "*discordants*" \) | tr "\n" " ")
    module load samtools
    samtools merge results/Merged.bam $Bams
    samtools index results/Merged.bam
    echo Done.
fi

conda activate whatshapenv
whatshap phase \
    --indels \
    --max-coverage 20 \
    -o results/Phased.vcf \
    results/Joint.vcf \
    results/Merged.bam
