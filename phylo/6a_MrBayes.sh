#!/bin/bash -l
#SBATCH --ntasks=16
#SBATCH --nodes=1
#SBATCH --mem=9G
#SBATCH --time=10-00:00:00
#SBATCH --mail-user=araje002@ucr.edu
#SBATCH --mail-type=ALL
#SBATCH -p batch
#SBATCH -o ../history/slurm-%A_%a.out

module load mrbayes/3.2.6
mpiexec -n $SLURM_NTASKS mb MrBayesPars/concatenated.par #Change the par file for whatever analysis you are running
