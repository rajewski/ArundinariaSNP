#!/bin/bash -l

# Directory with files to upload. All files here will be uploaded
INDIR=/bigdata/littlab/arajewski/CRISPRSeq/ExternalData/**/*.fastq.gz
# Temp directory to create on NCBI's servers
NCBIDIR=CRISPRseek2


module load aspera
ascp \
	-i /opt/linux/centos/7.x/x86_64/pkgs/aspera/3.6.0/etc/asperaweb_id_dsa.openssh \
	-QT \
	-k1 \
	-d \
	$INDIR \
	subasp@upload.ncbi.nlm.nih.gov:uploads/rajewski23_gmail.com_gZm1ZLeM/${NCBIDIR}
