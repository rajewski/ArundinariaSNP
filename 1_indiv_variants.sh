#!/bin/bash -l
#SBATCH --ntasks=4
#SBATCH --nodes=1
#SBATCH --mem=7G
#SBATCH --time=2:00:00
#SBATCH --mail-user=araje002@ucr.edu
#SBATCH --mail-type=ALL
#SBATCH -p batch
#SBATCH -o ./history/slurm-%A_%a.out

#get sample names for all files to be processed
SamList=~/bigdata/Arundinaria/names.txt
Sample=$(awk "NR==$SLURM_ARRAY_TASK_ID" $SamList)
Indiv=$(echo $Sample | cut -d "_" -f 2)

#optionally make the indices of the references files
module load bwa/0.7.12
if [ ! -f "references.fasta.ann" ]; then
    bwa index references.fasta
fi

if [ ! -f "references.fasta.fai" ]; then
    module load samtools/1.8
    samtools faidx references.fasta
fi

if [ ! -f "references.dict" ]; then
    module load picard/2.18.3
    picard CreateSequenceDictionary R=references.fasta O=references.dict
fi

#map the reads
if [ ! -f "results/"$Indiv".filtered.bam" ]; then
    ReadGroup=$(echo "\'@RG\tID:'$Indiv'\tSM:'$Indiv'\tLB:Lib\'")
    module load speedseq/a95704a
    speedseq align -t $SLURM_NTASKS -K speedseq.config -o results/$Indiv.filtered -R $ReadGroup references.fasta data/$Sample"_R1_filtered.fastq.gz" data/$Sample"_R2_filtered.fastq.gz"
fi

#Use GATK to make the VCF
module load gatk/4.0.8.1
gatk HaplotypeCaller -nt $SLURM_NTASKS --allow_potentially_misencoded_quality_scores -R references.fasta -I results/$Indiv.filtered.bam -O results/$Indiv.g.vcf -ERC GVCF
