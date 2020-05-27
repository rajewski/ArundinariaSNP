#!/bin/bash -l
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=30
#SBATCH --nodes=1
#SBATCH --mem=2G
#SBATCH --time=02:00:00
#SBATCH --mail-user=araje002@ucr.edu
#SBATCH --mail-type=ALL
#SBATCH -p short
#SBATCH -o ./history/SpeedSeq-%A.out
set -eu

# Make list of BAM files
# rm results/C12* results/D12* results/E12* results/F12* results/G12* results/H12*
Bams=$(find results/ \( -name "*.bam" -not -name "*splitters*" -not -name "*discordants*" -not -name "E11*" -not -name "Merged.bam" \) )
Bamsc=$(echo $Bams | sed 's/bam res/bam,res/g')
Disc=$(echo $Bamsc | sed 's/\.bam/\.discordants.bam/g')
Split=$(echo $Bamsc | sed 's/\.bam/\.splitters.bam/g')

# Call SNPs and indels
module load speedseq/a95704a
conda activate speedseq

echo $(date): Calling SNPs and indels with SpeedSeq var...
speedseq var \
    -o results/SpeedSeq \
    -t $SLURM_CPUS_PER_TASK \
    -K speedseq.config \
    References.fasta \
    $Bams
echo $(date): Done.

# Call structural variants
echo $(date): Calling structural variants with SpeedSeq sv...
speedseq sv \
    -o results/SpeedSeq \
    -t $SLURM_CPUS_PER_TASK \
    -K speedseq.config \
    -B $Bamsc \
    -D $Disc \
    -S $Split \
    -R References.fasta
echo $(date): Done.
