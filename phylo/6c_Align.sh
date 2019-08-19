#!/bin/bash -l
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --mem=4G
#SBATCH --time=00:30:00
#SBATCH --mail-user=araje002@ucr.edu
#SBATCH --mail-type=ALL
#SBATCH -p batch
#SBATCH -o ../history/align-%A.out
set -eu

module load muscle/3.8.425

muscle -in ~/bigdata/Arundinaria/results/Concatenated_ambig.fasta  > ~/bigdata/Arundinaria/phylo/concatenated/Concatenated_ambig.afa
