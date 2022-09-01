FROM rhub/r-minimal:4.3

LABEL maintainer="Alex Rajewski"
LABEL name="arundinaria-r"
LABEL version="1.0.0"

RUN installr -d \
  -a "cairo imagemagick imagemagick-dev libcurl libx11 libxml2" \
  -t "curl-dev libxml2-dev linux-headers gfortran" \
  Biostrings \
  cowplot \
  magick \
  ggrepel \
  gt \
  maps \
  phangorn \
  phytools \
  prettymapr \
  pryr \
  phytools \
  raster \
  gaborcsardi/readxl@fix/alpine-linux \
  tidyverse \
  vcfR

