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

#add in refs and outgroup to concatenated fasta
cat ~/bigdata/Arundinaria/phylo/concatenated/Refs.fasta ~/bigdata/Arundinaria/results/Concatenated_ambig.fasta > ./Concatenated_ambig.tmp

module load muscle/3.8.425
muscle -in Concatenated_ambig.tmp > ~/bigdata/Arundinaria/phylo/concatenated/Concatenated_ambig.afa
rm Concatenated_ambig.tmp
