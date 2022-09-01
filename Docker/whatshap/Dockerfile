FROM alpine:3.16.2

LABEL maintainer="Alex Rajewski"
LABEL name="Arundinaria"
LABEL version="0.1.0"

# whatshap change encoding
# https://stackoverflow.com/a/49127686/13954432 
ENV LC_ALL=C.UTF-8

# Update keys, etc bc older image broad institute and install jq
# https://askubuntu.com/a/1099431 # Remove man-db
# https://serverfault.com/a/906973 # Get Google keys
# https://askubuntu.com/a/1274398 # Refresh GPG keys
# https://stackoverflow.com/a/45716067/13954432 # Remove enum34
# https://github.com/pypa/pypi-legacy/issues/322#issuecomment-226940200 # python-setuptools-scm for whatshap

# RUN apt-get remove -y --purge man-db \
#  && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - \
#  && apt-key adv --refresh-keys --keyserver keyserver.ubuntu.com \
#  && apt-get update \
#  && apt-get -y install build-essential python3-dev \
#  && pip install --upgrade pip \
#  && pip uninstall -y enum34 \
#  && pip install setuptools_scm \
#  && pip install ffq whatshap \
#  && apt-get clean \
#  && rm -rf /var/lib/apt/lists/*

RUN apk update \
  && apk add --virtual build-stuff gcc make \
  && apk add py3-pip \
  && pip install whatshap \
  && apk del build-stuff
