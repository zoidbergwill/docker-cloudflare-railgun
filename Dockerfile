FROM debian:jessie-slim
# cloudflare-railgun 5.0.2
# docker run --name railgun-memcached -d --restart=always memcached
# docker run -d --restart=always --name railgun -p 2408:2408 --link railgun-memcached:memcached -e RG_ACT_TOKEN= -e RG_ACT_HOST= -e RG_LOG_LEVEL=1 rungeict/cloudflare-railgun

COPY configs/apt /scripts
ENV PATH $PATH:/scripts

MAINTAINER Matthew McKenzie <matthew.mckenzie@rungeict.com>

ENV RG_WAN_PORT 2408
ENV RG_LOG_LEVEL 0
ENV RG_ACT_TOKEN ""
ENV RG_ACT_HOST ""
ENV RG_MEMCACHED_SERVERS "memcached:11211"

RUN apt-get-install.sh ca-certificates curl && \
  echo 'deb http://pkg.cloudflare.com/ jessie main' | tee /etc/apt/sources.list.d/cloudflare-main.list && \
  curl -C - https://pkg.cloudflare.com/pubkey.gpg | apt-key add - && \
  apt-get-purge.sh curl && \
  apt-get-install.sh railgun-stable

COPY resources/ /

RUN chmod +x /docker-entrypoint.sh; chmod +x /usr/bin/railgun-conf.sh;

EXPOSE 2408

ENTRYPOINT /docker-entrypoint.sh
