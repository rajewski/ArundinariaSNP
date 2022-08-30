FROM broadinstitute/gatk:4.0.8.1

MAINTAINER Alex Rajewski
LABEL version="0.1.0"

# RUN apt-get update \
#  && apt-get -y install jq \
#  && 
#  && apt-get clean \
#  && rm -rf /var/lib/apt/lists/*