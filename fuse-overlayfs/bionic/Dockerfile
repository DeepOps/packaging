FROM ubuntu:bionic

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        curl \
        devscripts \
        fakeroot \
        software-properties-common \
    && rm -rf /var/lib/apt/lists/*

# Add PPA to get backported fuse3 package
RUN add-apt-repository ppa:luke-yeager/fuse-overlayfs
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        libfuse3-dev \
    && rm -rf /var/lib/apt/lists/*

RUN echo 'deb-src http://archive.ubuntu.com/ubuntu/ disco universe' >/etc/apt/sources.list.d/disco-universe-sources.list
RUN apt-get update \
    && apt-get build-dep -y fuse-overlayfs \
    && rm -rf /var/lib/apt/lists/*
WORKDIR /usr/local/src
RUN apt-get update \
    && apt-get source fuse-overlayfs \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/local/src/fuse-overlayfs-0.3

ARG DEBFULLNAME
ARG DEBEMAIL

RUN dch --nmu --empty ''
RUN dch --release ''

RUN debuild -i -us -uc -S
RUN debuild -i -us -uc -b
RUN mkdir /dist
RUN find .. -maxdepth 1 -type f -exec mv {} /dist \;
