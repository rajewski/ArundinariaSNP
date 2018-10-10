#!/bin/bash -l
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --mem=1G
#SBATCH --time=2:00:00
#SBATCH --mail-user=araje002@ucr.edu
#SBATCH --mail-type=ALL
#SBATCH -p batch
#SBATCH -o ../history/slurm-%A_%a.out

