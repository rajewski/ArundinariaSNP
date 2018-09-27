#!/bin/bash -l
#SBATCH --ntasks=4
#SBATCH --nodes=1
#SBATCH --mem=7G
#SBATCH --time=2:00:00
#SBATCH --mail-user=araje002@ucr.edu
#SBATCH --mail-type=ALL
#SBATCH -p batch

#get sample names for all files to be processed
#SamList=~/bigdata/Arundinaria/names.txt
#Sample=$(awk "NR==$SLURM_ARRAY_TASK_ID" $SamList)
#Indiv=$(echo $Sample | cut -d "_" -f 2)
Bams=$(find results/ -name "*.filtered.bam" | tr "\n" " ")

source activate pythree
whatshap phase --indels --max-coverage 20 -o results/Phased.vcf results/Joint.vcf $Bams
