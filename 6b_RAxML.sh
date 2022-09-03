#!/bin/bash -l
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --mem-per-cpu=4G
#SBATCH --time=4:00:00
#SBATCH --mail-user=araje002@ucr.edu
#SBATCH --mail-type=ALL
#SBATCH -o ../history/RAxML-%A.out

# Note: I am not going to make any containers for the phylogenetic softwares. They are simply too complex.
# Because I will have no way to run them locally and test, I am not going to really modify these scripts
# except to flesh out parts that I ran interactively with more thorough code. For that reason, you will 
# need to be careful about the paths that are used. I have left local paths in  place, but they could 
# be a source of trouble later for you.

# Get paths
source 0_Containers.env

module load RAxML_NG/0.9.0
cd /rhome/arajewski/bigdata/Arundinaria/phylo/plastid/GTRGI || exit
ALIGNIN="${path_results_local}/Results/PHYLO/Plastid_NoMissing_rpl32.phy"

# Parse the alignment and estimate the mem and CPU reqs.
if [ ! -e "$ALIGNIN.raxml.rba" ]; then
    echo "$(date): Estimating time to completion."
    raxml-ng --parse \
	--msa $ALIGNIN \
	--model GTR+G+I \
	--prefix $ALIGNIN
    echo "$(date): Done."
else
    echo "$(date): Parsing already complete"
fi

# Actualy run the analysis
echo "$(date): Beginning RAxML estimation."
raxml-ng --all \
    --tree pars{25},rand{25} \
    --msa $ALIGNIN \
    --prefix $ALIGNIN \
    --model GTR+G+I \
    --outgroup 'P.edulis' \
    --seed 121787 \
    --blopt nr_safe \
    --threads "$SLURM_NTASKS"

# previous version of RAxML
# module load RAxML/8.2.11
# raxmlHPC-PTHREADS-SSE3 \
#   -f a \
#   -m GTRGAMMAI \
#   -p 121787 \
#   -x 92191 \
#   -N 1000 \
#   -T $SLURM_NTASKS \
#   -s concatenated/Concatenated_ambig.phy \
#   -w ~/bigdata/Arundinaria/phylo/concatenated/GTRGI \
#   -n Concatenated_amibg.RAxML 
