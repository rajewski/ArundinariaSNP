#!/bin/bash -l
#SBATCH --ntasks=16
#SBATCH --nodes=1
#SBATCH --mem=9G
#SBATCH --time=10-00:00:00
#SBATCH --mail-type=ALL
#SBATCH -p batch

# Note: I am not going to make any containers for the phylogenetic softwares. They are simply too complex.
# Because I will have no way to run them locally and test, I am not going to really modify these scripts
# except to flesh out parts that I ran interactively with more thorough code. For that reason, you will 
# need to be careful about the paths that are used. I have left local paths in  place, but they could 
# be a source of trouble later for you.

# load the packages
module load mrbayes/3.2.6

# Get paths
source 0_Containers.env

# The .par file changes with each run
mpiexec -n "$SLURM_NTASKS" mb "${path_ref_local}/MrBayes_concatenated.par"
mpiexec -n "$SLURM_NTASKS" mb "${path_ref_local}/MrBayes_LFY.par"
mpiexec -n "$SLURM_NTASKS" mb "${path_ref_local}/MrBayes_matK.par"
mpiexec -n "$SLURM_NTASKS" mb "${path_ref_local}/MrBayes_plastid_nomissing.par"
mpiexec -n "$SLURM_NTASKS" mb "${path_ref_local}/MrBayes_plastid.par"
mpiexec -n "$SLURM_NTASKS" mb "${path_ref_local}/MrBayes_WXY.par"
