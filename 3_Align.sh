#!/bin/bash -l
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --nodes=1
#SBATCH --mem=2G
#SBATCH --time=2:00:00
#SBATCH --mail-user=araje002@ucr.edu
#SBATCH --mail-type=ALL
#SBATCH -p short
#SBATCH -o ./history/Align-%A_%a.out

#get sample names for all files to be processed
SampleList=./Names.txt
Sample=$(awk "NR==$SLURM_ARRAY_TASK_ID" $SampleList)
#Indiv=$(echo $Sample | cut -d "_" -f 2)

#map the reads
if [ ! -f results/${Sample}.bam ]; then
    module load speedseq/a95704a
    # Currently this ignores inpaired reads though they are output from the demultiplexing with the suffix *.rem.fq.gz
    speedseq align \
	-t $SLURM_NTASKS \
	-K speedseq.config \
	-o results/$Sample \
	-R '@RG\tID:'$Sample'\tSM:'$Sample'\tLB:Lib\' \
	References.fasta \
	ExternalData/Pooled/Stacks/${Sample}.1.fq.gz ExternalData/Pooled/Stacks/${Sample}.2.fq.gz
fi

#Use GATK to make the VCF
module load gatk/4.0.8.1
gatk HaplotypeCaller \
    -R References.fasta \
    -I results/$Sample.bam \
    -O results/$Sample.g.vcf \
    -ERC GVCF
