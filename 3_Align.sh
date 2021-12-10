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
FLOW=Flowcell_1304
mkdir -p results/$FLOW

#map the reads
if [ ! -f results/$FLOW/${Sample}.bam ]; then
    module load speedseq/a95704a
    # Currently this ignores inpaired reads though they are output from the demultiplexing with the suffix *.rem.fq.gz
    speedseq align \
	-t $SLURM_NTASKS \
	-K speedseq.config \
	-o results/$FLOW/$Sample \
	-R '@RG\tID:'$Sample'\tSM:'$Sample'\tLB:Lib\' \
	References.fasta \
	ExternalData/$FLOW/Pooled/Stacks/${Sample}.1.fq.gz ExternalData/$FLOW/Pooled/Stacks/${Sample}.2.fq.gz
fi
