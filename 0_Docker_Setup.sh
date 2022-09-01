#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

# Set local and docker paths for volume mounting
# ...set dir names
__repo="$(pwd)"
dir_fastq="FASTQ"
dir_ref="References"
dir_results="Results/"

# ...set paths on docker
path_fastq_docker="/root/${dir_fastq}"
path_ref_docker="/root/${dir_ref}"
path_results_docker="/root/${dir_results}"

# ...set paths on local
path_fastq_local="${__repo}/${dir_fastq}"
path_ref_local="${__repo}/${dir_ref}"
path_results_local="${__repo}/${dir_results}"

# Create mounting variables
MOUNT_FASTQ="${path_fastq_local}":"${path_fastq_docker}"
MOUNT_REF="${path_ref_local}":"${path_ref_docker}"
MOUNT_RESULTS="${path_results_local}":"${path_results_docker}"

# Set alias for running containers. Made as arrays that get expanded to form command with e.g. ${_bwa[@]} mem
# https://stackoverflow.com/a/71600549/13954432
## ffq |jq

## BWA
_bwa=(docker run --rm
      -v $MOUNT_REF 
      cca65af5ecf2 bwa )

## samtools
_samtools=( docker run --rm 
            -v $MOUNT_REF 
            4d058e679701 
            samtools )

## SpeedSeq
_speedseq=( docker run --rm
            -v $MOUNT_FASTQ
            -v $MOUNT_REF 
            -v $MOUNT_RESULTS
            5822ba0d5f4e 
            /speedseq/bin/speedseq )

## GATK
_gatk=( docker run --rm 
        -v "$MOUNT_REF"
        -v "$MOUNT_RESULTS"
        123712a62f94 
        gatk)
        
## bcftools
_bcftools=( docker run --rm
            -v "$MOUNT_RESULTS"
            239994ebcd8d
            bcftools)

## R

## Whatshap
_whatshap=( docker run --rm
            -v "$MOUNT_RESULTS"
            05fc6374672d
            whatshap ) 
