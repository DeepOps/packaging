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

# Add PPA to get fixed pmix package
RUN add-apt-repository ppa:luke-yeager/slurm
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        'libpmix-dev=3.1.2-3.1' \
    && rm -rf /var/lib/apt/lists/*

RUN echo 'deb-src http://archive.ubuntu.com/ubuntu/ disco universe' >/etc/apt/sources.list.d/disco-universe-sources.list
RUN apt-get update \
    && apt-get build-dep -y slurm-wlm \
    && rm -rf /var/lib/apt/lists/*
WORKDIR /usr/local/src
RUN apt-get update \
    && apt-get source slurm-wlm \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/local/src/slurm-llnl-18.08.6.2

ARG DEBFULLNAME
ARG DEBEMAIL

RUN dch --nmu --empty ''
RUN curl -fSsL 'https://salsa.debian.org/hpc-team/slurm-wlm/merge_requests/1.diff' | patch -p1 \
    && dch -a 'Build pam_slurm_adopt package'
COPY pmix.patch /tmp/pmix.patch
RUN patch -p1 </tmp/pmix.patch \
    && chmod +x debian/slurm-wlm-basic-plugins.links \
    && dch -a 'Build with pmix'
RUN dch --nmu 'Rebuild against new pmix packages with fixed symlinks'
RUN dch --nmu 'Rebuild against pmix v3 packages'
RUN dch --release ''

RUN debuild -i -us -uc -S
RUN mkdir /dist
RUN find .. -maxdepth 1 -type f -name 'slurm*' -exec mv {} /dist \;
