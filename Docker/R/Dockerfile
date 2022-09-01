FROM rhub/r-minimal:4.3

LABEL maintainer="Alex Rajewski"
LABEL name="arundinaria-r"
LABEL version="1.0.0"

RUN installr -d \
  -a "cairo imagemagick imagemagick-dev libcurl libx11 libxml2 gdal proj geos sqlite" \
  -t "curl-dev libxml2-dev linux-headers gfortran gdal-dev proj-dev geos-dev sqlite-dev build-base" \
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

