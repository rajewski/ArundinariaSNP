#!/bin/bash -l
#SBATCH --ntasks=10
#SBATCH --nodes=1
#SBATCH --mem=1G
#SBATCH --time=04:00:00
#SBATCH --mail-user=araje002@ucr.edu
#SBATCH --mail-type=ALL
#SBATCH -p batch
#SBATCH -o ../../history/slurm-%A.out
set -euv

# $((SLURM_MEM_PER_NODE/1000))'G'
# $SLURM_NTASKS

# echo $SLURM_NTASKS is the number of core
# echo $SLURM_MEM_PER_NODE is the amount of memory

java -jar /opt/linux/centos/7.x/x86_64/pkgs/jmodeltest2/2.1.10/jModelTest.jar -d ../concatenated/TESTconcatenated.phy -f -i -g 4 -s 3 -AIC -AICc -DT -BIC -tr $SLURM_NTASKS -o TESTJimmyConcatenated.out
