#!/usr/bin/env bash

# Get vars for running commands
source 0_Paths.env
source 0_Containers.env

# Pull docker containers SHA follows comment
docker pull rajewski/getfq:v1.0.0 # f5ab3815f4ff
docker pull quay.io/biocontainers/bwa:0.7.17--h7132678_9 # cca65af5ecf2
docker pull quay.io/biocontainers/samtools:1.8--h46bd0b3_5 # 4d058e679701
docker pull kfdrc/speedseq:latest # 5822ba0d5f4e
docker pull broadinstitute/gatk:4.0.8.1 # 123712a62f94
## R
docker pull quay.io/biocontainers/bcftools:1.15.1--h0ea216a_0 # 239994ebcd8d
docker pull quay.io/biocontainers/whatshap:1.2.1--py37h22450f8_0 # 05fc6374672d
docker pull biocontainers/plink1.9:v1.90b6.6-181012-1-deb_cv1 # 87189de4a191

# Get sample list
# requires both ffq and jq to be installed
if [ ! -e "${path_ref_local}/ftpLinks.txt" ]; then
    ${_getfq[@]} ffq --ftp SRP234396 | jq -r '.[] | .url' > "${path_ref_local}/ftpLinks.txt"
fi

# Download samples
while read -r link; do
    curl -O \
      --output-dir "${path_fastq_local}" \
      "$link"
done < "${path_ref_local}/ftpLinks.txt"

