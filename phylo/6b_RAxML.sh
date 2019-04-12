#!/bin/bash -l
#SBATCH --ntasks=5
#SBATCH --nodes=1
#SBATCH --mem-per-cpu=4G
#SBATCH --time=08:00:00
#SBATCH --mail-user=araje002@ucr.edu
#SBATCH --mail-type=ALL
#SBATCH -o ../history/slurm-%A.out

module load RAxML/8.2.11
raxmlHPC-PTHREADS-SSE3 -f a -m GTRGAMMAI -p 121787 -x 92191 -N 1000 -T $SLURM_NTASKS -s plastid/Plastid_NoMissingrenamedJimmy.phy -w ~/bigdata/Arundinaria/phylo/plastid/GTRGI -n Plastid_NoMissingrenamedJimmy.RAxML 
