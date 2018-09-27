#!/bin/bash -l
#SBATCH --ntasks=4
#SBATCH --nodes=1
#SBATCH --mem=7G
#SBATCH --time=2:00:00
#SBATCH --mail-user=araje002@ucr.edu
#SBATCH --mail-type=ALL
#SBATCH -p batch

#get sample names for all files to be processed
SamList=~/bigdata/Arundinaria/names.txt
Sample=$(awk "NR==$SLURM_ARRAY_TASK_ID" $SamList)
Indiv=$(echo $Sample | cut -d "_" -f 2)

#Load pear to do the merging
module load pear/0.9.10
pear -f data/$Sample"_R1_filtered.fastq.gz" -r data/$Sample"_R2_filtered.fastq.gz" -o $Indiv -q 20 -y $((SLURM_MEM_PER_NODE/1000))'G' -j $SLURM_NTASKS 

#Load bowtie to map and make BAM
module load bowtie2/2.3.4.1

#optionally make the bowtie index of the references files
if [ ! -f "amplicons.1.bt2" ]; then
  bowtie2-build references.fasta amplicons
fi

#map the reads
bowtie2 -x amplicons -U $Indiv".unassembled.forward.fastq",$Indiv".unassembled.reverse.fastq",$Indiv".assembled.fastq" -p $SLURM_NTASKS -S $Indiv.sam

#use samtools to curate the sample file
module load samtools
samtools view -S -b $Indiv.sam > $Indiv.bam
samtools sort $Indiv.bam -o $Indiv.sort.bam
#samtools rmdup -s $Indiv.sort.bam $Indiv.sort.bam

#use samtools and bcftools to make the vcf file
module load bcftools/1.8
samtools mpileup -uf references.fasta $Indiv.sort.bam | bcftools call -mv > $Indiv.vcf
samtools calmd -AEur $Indiv.sort.bam references.fasta | samtools phase -b $Indiv.phase - > $Indiv.phase.out
#I think i could use samtools phase to phase the variants but Ruidong used Whatshap and I want to rpelciate his first

#Phase variants with Whatshap
#module load Whatshap






#samtools merge with -r and maybe -h samples.tsv to get the read groups for a combined BAM
#Load FreeBayes to make the VCF
#Something something with read groups and Picard in the VCF to make Whatshap work better??
