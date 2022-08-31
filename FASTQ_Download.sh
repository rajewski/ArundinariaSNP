#!/usr/bin/env bash

# Get sample list
# requires both ffq and jq to be installed
if [ ! -e ftpLinks.txt ]; then
    ffq --ftp SRP234396 | jq -r '.[] | .url' > References/ftpLinks.txt
fi

# Download samples
while read -r link; do
    curl -O \
      --output-dir References \
      "$link"
done < References/ftpLinks.txt

