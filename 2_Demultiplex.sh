#!/bin/bash -l
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=6
#SBATCH --nodes=1
#SBATCH --mem=7G
#SBATCH --time=2:00:00
#SBATCH --mail-user=araje002@ucr.edu
#SBATCH --mail-type=ALL
#SBATCH -p short
#SBATCH -o ./history/Demultiplex-%A.out
set -e

FLOW=Flowcell_1304
R1=AR_Litt_library_S1_R1_001
R2=AR_Litt_library_S1_R2_001
# Move the multiplexed data to its own folder
mkdir -p ExternalData/$FLOW/Pooled
ln -sf /bigdata/littlab/arajewski/CRISPRSeq/ExternalData/$FLOW/$R1.fastq.gz ExternalData/$FLOW/Pooled/$R1.fastq.gz
ln -sf /bigdata/littlab/arajewski/CRISPRSeq/ExternalData/$FLOW/$R2.fastq.gz ExternalData/$FLOW/Pooled/$R2.fastq.gz

# Run TrimGalore real quick to see what sort of adapter contamination is in the multiplexed data
if [ ! -e ExternalData/$FLOW/Pooled/${R2}_val_2.fq.gz ]; then
    #Set up the right env for multithreaded trimming
    module load fastqc
    conda activate cutadaptenv
    export PATH=/bigdata/littlab/arajewski/Datura/software/TrimGalore-0.6.5:$PATH
    # Do a quick qc to see if this is necessary
    fastqc -t $SLURM_CPUS_PER_TASK ExternalData/$FLOW/Pooled/$R1.fastq.gz ExternalData/$FLOW/Pooled/$R2.fastq.gz
    # Ok it was so now:
    echo Running Trim Galore...
    trim_galore \
        --paired \
        -j $SLURM_CPUS_PER_TASK \
        -o ExternalData/$FLOW/Pooled \
        ExternalData/$FLOW/Pooled/$R1.fastq.gz ExternalData/$FLOW/Pooled/$R2.fastq.gz 
    # Make sure it actually improved the file
    fastqc -t $SLURM_CPUS_PER_TASK ExternalData/$FLOW/Pooled/${R1}_val_1.fq.gz ExternalData/$FLOW/Pooled/${R2}_val_2.fq.gz
    echo Done.
else
    echo Already trimmed.
fi 

# Make barcodes file
awk  '{ print $2 "\t" $1 }' ./barcodes.txt | tail -n +2 > ExternalData/$FLOW/Pooled/barcodes.txt
mkdir -p ExternalData/$FLOW/Pooled/Stacks

# Run Stacks to demultiplex
module load stacks/2.1
process_radtags \
    -P \
    -1 ExternalData/$FLOW/Pooled/${R1}_val_1.fq.gz \
    -2 ExternalData/$FLOW/Pooled/${R2}_val_2.fq.gz \
    -o ExternalData/$FLOW/Pooled/Stacks/ \
    --renz_1 pstI \
    --renz_2 mspI \
    -q \
    -r \
    -b ExternalData/$FLOW/Pooled/barcodes.txt \
    --inline_null
