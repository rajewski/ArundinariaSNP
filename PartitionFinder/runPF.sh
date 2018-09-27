#!/bin/bash -l
#SBATCH --ntasks=16
#SBATCH --nodes=1
#SBATCH --mem=5G
#SBATCH --time=20:00:00
#SBATCH --mail-user=araje002@ucr.edu
#SBATCH --mail-type=ALL
#SBATCH -p batch

# $((SLURM_MEM_PER_NODE/1000))'G'
# $SLURM_NTASKS

module load python/2.7.12
module load PartitionFinder

PartitionFinder.py -p $SLURM_NTASKS ./ 
