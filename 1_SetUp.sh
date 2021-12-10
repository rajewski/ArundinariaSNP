#!/bin/bash -l
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --nodes=1
#SBATCH --mem=7G
#SBATCH --time=2:00:00
#SBATCH --mail-user=araje002@ucr.edu
#SBATCH --mail-type=ALL
#SBATCH -p short
#SBATCH -o ./history/SetUp-%A_%a.out

# Copy the MiSeq data
mkdir -p ExternalData/Flowcell_1304
curl --user alitt:"pMgrYEH'NXkb" http://cluster.hpcc.ucr.edu/~mcollin/alitt/1304/200828_M02457_0476_000000000-JBBRV/AR_Litt_library_S1_R1_001.fastq.gz > ExternalData/Flowcell_1304/AR_Litt_library_S1_R1_001.fastq.gz
curl --user alitt:"pMgrYEH'NXkb" http://cluster.hpcc.ucr.edu/~mcollin/alitt/1304/200828_M02457_0476_000000000-JBBRV/AR_Litt_library_S1_R2_001.fastq.gz > ExternalData/Flowcell_1304/AR_Litt_library_S1_R2_001.fastq.gz

# Mand indices of the references file  
if [ ! -f References.fasta.ann ]; then
    module load bwa/0.7.12
    bwa index References.fasta
fi

if [ ! -f References.fasta.fai ]; then
    module load samtools/1.8
    samtools faidx References.fasta
fi

if [ ! -f References.dict ]; then
    module load picard/2.18.3
    picard CreateSequenceDictionary R=References.fasta O=References.dict
fi
