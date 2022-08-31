#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

__repo="$(pwd)"

# Set local and docker paths for volume mounting
# ...set dir names
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
################################################################################

################################################################################
# Create mounting variables
#
MOUNT_FASTQ="${path_fastq_local}":"${path_fastq_docker}"
MOUNT_REF="${path_ref_local}":"${path_ref_docker}"
MOUNT_RESULTS="${path_results_local}":"${path_results_docker}"
