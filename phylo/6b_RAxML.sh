#!/bin/bash -l
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --mem-per-cpu=4G
#SBATCH --time=10:00:00
#SBATCH --mail-user=araje002@ucr.edu
#SBATCH --mail-type=ALL
#SBATCH -o ../history/RAxML-%A.out

#previous version of RAxML
#module load RAxML/8.2.11
#raxmlHPC-PTHREADS-SSE3 -f a -m GTRGAMMAI -p 121787 -x 92191 -N 1000 -T $SLURM_NTASKS -s concatenated/Concatenated_ambig.phy -w ~/bigdata/Arundinaria/phylo/concatenated/GTRGI -n Concatenated_amibg.RAxML 

module load RAxML_NG/0.9.0
cd /rhome/arajewski/bigdata/Arundinaria/phylo/concatenated/GTRGI
ALIGNIN=Concatenated_ambig.afa

if [ ! -e '$ALIGNIN.raxml.rba' ];then
    #command to parse the alignment and estimate the mem and CPU reqs.
    echo $(date): Estimating time to completion.
    raxml-ng --parse --msa ../$ALIGNIN --model GTR+G+I 
    echo $(date): Done.
fi

#actualy run the analysis
echo $(date): Beginning RAxML estimation.
raxml-ng --all --msa $ALIGNIN --model GTR+G+I --bs-trees autoMRE --seed 121787 --threads $SLURM_NTASKS

#print job information for later reference
scontrol show job $SLURM_JOB_ID
