#!/bin/bash -l
#SBATCH --ntasks=8
#SBATCH --nodes=1
#SBATCH --mem=3G
#SBATCH --time=02:00:00
#SBATCH --mail-user=araje002@ucr.edu
#SBATCH --mail-type=ALL
#SBATCH -p batch
#SBATCH -o ../../history/slurm-%A.out
set -euv

# $((SLURM_MEM_PER_NODE/1000))'G'
# $SLURM_NTASKS

module load splitstree4/4.14.6
SplitsTree -g -c concatenated.par
