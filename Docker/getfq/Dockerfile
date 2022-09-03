FROM alpine:3.16.2

LABEL maintainer="Alex Rajewski"
LABEL name="getfq"
LABEL version="1.0.0"

# Install ffq and jq
RUN apk update \
  && apk add py3-pip jq \
  && pip install ffq
