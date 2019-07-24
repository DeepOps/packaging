FROM ubuntu:bionic

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        curl \
        devscripts \
        equivs \
        fakeroot \
        software-properties-common \
    && rm -rf /var/lib/apt/lists/*

# Add PPA to get backported fuse3 package
RUN add-apt-repository ppa:luke-yeager/fuse-overlayfs
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        libfuse3-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/local/src
RUN curl -fsSL -o fuse-overlayfs_0.4.1.orig.tar.gz https://github.com/containers/fuse-overlayfs/archive/v0.4.1.tar.gz
WORKDIR /usr/local/src/fuse-overlayfs
RUN tar -x -f ../fuse-overlayfs_0.4.1.orig.tar.gz --strip-components=1
RUN mkdir -p debian && cd debian \
    && curl -fsSL -o /tmp/src.tar.gz https://salsa.debian.org/debian/fuse-overlayfs/-/archive/2cc67417979e47f9487b935eeb91b3b99f87e0e7/fuse-overlayfs-2cc67417979e47f9487b935eeb91b3b99f87e0e7.tar.gz?path=debian \
    && tar -x -f /tmp/src.tar.gz --strip-components=2 \
    && rm /tmp/src.tar.gz
COPY bionic-0.4.1.patch /tmp/bionic-0.4.1.patch
RUN patch -p1 </tmp/bionic-0.4.1.patch

RUN apt-get update \
    && yes | mk-build-deps --install --remove \
    && rm -rf /var/lib/apt/lists/*

ARG DEBFULLNAME
ARG DEBEMAIL

RUN debuild -i -us -uc -S
RUN debuild -i -us -uc -b
RUN mkdir /dist
RUN find .. -maxdepth 1 -type f -exec mv {} /dist \;
