FROM broadinstitute/gatk:4.0.8.1

LABEL maintainer="Alex Rajewski"
LABEL name="Arundinaria"
LABEL version="0.1.0"

# https://stackoverflow.com/a/49127686/13954432 # whatshap change encoding
ENV LC_ALL=C.UTF-8

# Update keys, etc bc older image broad institute and install jq
# https://askubuntu.com/a/1099431 # Remove man-db
# https://serverfault.com/a/906973 # Get Google keys
# https://askubuntu.com/a/1274398 # Refresh GPG keys
# https://stackoverflow.com/a/45716067/13954432 # Remove enum34
# https://github.com/pypa/pypi-legacy/issues/322#issuecomment-226940200 # python-setuptools-scm for whatshap

RUN apt-get remove -y --purge man-db \
  && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - \
  && apt-key adv --refresh-keys --keyserver keyserver.ubuntu.com \
  && apt-get update \
  && apt-get -y install bcftools build-essential git jq perl pod2pdf python3-dev texinfo \
  && pip install --upgrade pip \
  && pip uninstall -y enum34 \
  && pip install setuptools_scm \
  && pip install ffq whatshap \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Install BWA
RUN wget -O- --no-check-certificate https://sourceforge.net/projects/bio-bwa/files/bwa-0.7.12.tar.bz2/download  | tar xjf - \
  && cd bwa-0.7.12 || exit \
  && make \
  && cd /gatk || exit
  
# Install samtools
RUN wget --no-check-certificate https://github.com/samtools/samtools/releases/download/1.8/samtools-1.8.tar.bz2 \
	&& tar xfj samtools-1.8.tar.bz2 \
	&& cd samtools-1.8 || exit \
	&& ./configure \
	&& make \
	&& make install \
	&& cd /gatk || exit \
	&& rm samtools-1.8.tar.bz2
	
# Install Picard
RUN wget https://github.com/broadinstitute/picard/releases/download/2.18.3/picard.jar
ENV picard='java -jar /gatk/picard.jar'

# Install speedseq
# with help from https://github.com/ContinuumIO/docker-images/issues/89#issuecomment-440574150
RUN conda create -n speedseq python=2.7 numpy pysam>=0.8.0 scipy \
  && /bin/bash -c ". activate speedseq" \
  && git clone --recursive https://github.com/hall-lab/speedseq \
  && cd speedseq || exit \
  && make align \
  && cd /gatk ||exit \
  && /bin/bash -c ". activate gatk"
ENV PATH=/gatk/speedseq/bin:$PATH

# Add bcftools v1.8 with apt-get
# Install R with vcfR biocLite Biostrings phangorn ggplot2 ggrepel pryr cowplot gt tidyverse devtools pythools maps prettymapr raster