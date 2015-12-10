FROM ubuntu:15.04
# cloudflare-railgun 5.0.2
# docker run --name railgun-memcached -d memcached
# docker run rungeict/cloudflare-railgun -d --name railgun --expose 2408:2408 --link railgun-memcached:memcached

MAINTAINER Matthew McKenzie <matthew.mckenzie@rungeict.com>

ENV RG_WAN_PORT 2408
ENV RG_LOG_LEVEL 0
ENV RG_ACT_TOKEN ""
ENV RG_ACT_HOST ""

RUN apt-get update && \
  apt-get install -y curl && \
  echo 'deb http://pkg.cloudflare.com/ vivid main' | tee /etc/apt/sources.list.d/cloudflare-main.list && \
  curl -C - https://pkg.cloudflare.com/pubkey.gpg | apt-key add - && \
  apt-get update && \
  apt-get install -y railgun-stable && \
  apt-get purge curl -y && \
  apt-get autoremove -y &&  \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

COPY resources/ /

RUN chmod +x /docker-entrypoint.sh; chmod +x /usr/bin/railgun-conf.sh;

EXPOSE 2408

ENTRYPOINT /docker-entrypoint.sh