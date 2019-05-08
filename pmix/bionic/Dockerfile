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

RUN sed -i 's/# deb-src/deb-src/' /etc/apt/sources.list
RUN apt-get update \
    && apt-get build-dep -y pmix \
    && rm -rf /var/lib/apt/lists/*
WORKDIR /usr/local/src
RUN apt-get update \
    && apt-get source pmix \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/local/src/pmix-2.1.1~rc1

ARG DEBFULLNAME
ARG DEBEMAIL

RUN dch --nmu --empty ''
COPY links.patch /tmp/links.patch
RUN patch -p1 </tmp/links.patch \
    && dch -a 'Fix library symlinks'
RUN dch --release ''

RUN debuild -i -us -uc -S
RUN mkdir /dist
RUN find .. -maxdepth 1 -type f -name 'pmix*' -exec mv {} /dist \;
