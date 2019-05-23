FROM ubuntu:bionic

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        curl \
        devscripts \
        fakeroot \
        libpmix-dev \
    && rm -rf /var/lib/apt/lists/*

RUN echo 'deb-src http://archive.ubuntu.com/ubuntu/ disco universe' >/etc/apt/sources.list.d/disco-universe-sources.list
RUN apt-get update \
    && apt-get build-dep -y pmix \
    && rm -rf /var/lib/apt/lists/*
WORKDIR /usr/local/src
RUN apt-get update \
    && apt-get source pmix \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/local/src/pmix-3.1.2

ARG DEBFULLNAME
ARG DEBEMAIL

RUN dch --nmu --empty ''
RUN dch --release ''

RUN debuild -i -us -uc -S
RUN debuild -i -us -uc -b
RUN mkdir /dist
RUN find .. -maxdepth 1 -type f -exec mv {} /dist \;
