FROM rocker/geospatial:4.2.1-ubuntugis

LABEL maintainer="Alex Rajewski"
LABEL name="arundinaria-r"
LABEL version="1.0.0"

# Install the one bioconductor package we need 
# install it first to cache the lengthy build time
RUN R -e 'BiocManager::install(c("Biostrings"), update=FALSE)'
  
# Install CRAN packages
# do we need magick?
RUN install2.r --error \
  cowplot \
  ggrepel \
  gt \
  phangorn \
  phytools \
  prettymapr \
  pryr \
  vcfR
  
RUN apt-get update \
  && apt-get install -y xdg-utils

# At some point add in either headless chrome or phantomjs to plot gt() objects