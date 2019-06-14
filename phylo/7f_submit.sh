#!/bin/bash -l
#SBATCH --ntasks=3
#SBATCH --nodes=1
#SBATCH --mem=20G
#SBATCH --time=6-00:00:00
#SBATCH --mail-user=araje002@ucr.edu
#SBATCH --mail-type=ALL
#SBATCH -p batch
#SBATCH -o ../history/7f_Cophylo-%A.out
set -euv

Rscript 7f_Cophylo.R
