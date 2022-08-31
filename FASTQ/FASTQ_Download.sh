#!/usr/bin/env bash

# Get sample list
# requires both ffq and jq to be installed
if [ ! -e ftpLinks.txt ]; then
    ffq --ftp SRP234396 | jq -r '.[] | .url' > ftpLinks.txt
fi

# Download samples
while read -r link; do
    curl -O "$link"
done < ftpLinks.txt

