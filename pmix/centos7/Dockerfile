FROM centos:7
RUN yum makecache fast \
    && yum install -y epel-release \
    && yum makecache fast \
    && yum groupinstall -y 'Development Tools' \
    && yum install -y \
        libevent-devel \
        libtool-ltdl-devel \
        infinipath-psm-devel \
        munge-devel \
        wget \
        zlib-devel
WORKDIR /workdir
ARG PMIX_VERSION=2.1.4
RUN wget -q "https://github.com/pmix/pmix/releases/download/v2.1.4/pmix-${PMIX_VERSION}.tar.bz2"
RUN rpmbuild -ta pmix-*.tar.bz2 --define 'configure_options --with-psm'
RUN mkdir -p /dist
RUN cp /root/rpmbuild/RPMS/x86_64/*.rpm /dist/
