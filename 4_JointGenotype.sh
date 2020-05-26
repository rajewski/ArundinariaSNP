#!/bin/bash -l
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --mem=7G
#SBATCH --time=2:00:00
#SBATCH --mail-user=araje002@ucr.edu
#SBATCH --mail-type=ALL
#SBATCH -p short
#SBATCH -o ./history/Combine-%A.out

#get sample names for all files to be processed
Samps=$(find results/ -name "*.g.vcf" |sed 's/.*/-V &/' | tr "\n" " ")

#Use GATK to make the VCF
module load gatk/4.0.8.1
if [ ! -d "fruitfull" ]; then
    gatk GenomicsDBImport \
	$Samps \
	--genomicsdb-workspace-path fruitfull \
	-L NoFUL1.1 \
	-L NoFUL1.2 \
	-L NoFUL2.1 \
	-L NoFUL2.2 \
	-L NoMBP10 \
	-L NoMBP20.1 \
	-L NoMBP20.2 \
	-L SpFUL1 \
	-L SpFUL2 \
	-L SpMBP10 \
	-L SpMBP20.1 \
	-L SpMBP20.2
fi

gatk GenotypeGVCFs \
    -R References.fasta \
    -V gendb://fruitfull \
    -G StandardAnnotation \
    -O results/Joint.vcf

