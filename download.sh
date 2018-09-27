#!/bin/bash -l
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --mem=2G
#SBATCH --time=2:00:00
#SBATCH --mail-user=araje002@ucr.edu
#SBATCH --mail-type=ALL
#SBATCH -p batch

# $((SLURM_MEM_PER_NODE/1000))'G'
# $SLURM_NTASKS

#determine the sample to work on for this job (must be an array job)
SampList=~/bigdata/Arundinaria/data/samplenames.csv
Sample=$(awk "NR==$SLURM_ARRAY_TASK_ID" $SampList)
starting1=3234
starting2=27
Index1=$(($SLURM_ARRAY_TASK_ID+$starting1))
Index2=$(($SLURM_ARRAY_TASK_ID+$starting2))

wget --user="hwetzste" --password="pack.assort" "https://genomics.rcac.purdue.edu/users/hwetzste/wr00670/00"$Index1"_"$Sample"/Unaligned/00"$Index1"_"$Sample"_S"$Index2"_L001_R1_001.fastq.gz"

wget --user="hwetzste" --password="pack.assort" "https://genomics.rcac.purdue.edu/users/hwetzste/wr00670/00"$Index1"_"$Sample"/Unaligned/00"$Index1"_"$Sample"_S"$Index2"_L001_R2_001.fastq.gz"

wget --user="hwetzste" --password="pack.assort" "https://genomics.rcac.purdue.edu/users/hwetzste/wr00670/00"$Index1"_"$Sample"/Unaligned_filtered/00"$Index1"_"$Sample"_S"$Index2"_R1_filtered.fastq.gz"

wget --user="hwetzste" --password="pack.assort" "https://genomics.rcac.purdue.edu/users/hwetzste/wr00670/00"$Index1"_"$Sample"/Unaligned_filtered/00"$Index1"_"$Sample"_S"$Index2"_R2_filtered.fastq.gz"
