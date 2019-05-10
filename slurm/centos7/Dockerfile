FROM centos:7
RUN yum makecache fast \
    && yum install -y epel-release \
    && yum makecache fast \
    && yum groupinstall -y 'Development Tools' \
    && yum install -y \
        freeipmi-devel \
        hwloc-devel \
        libcurl-devel \
        mariadb-devel \
        mariadb-libs \
        man2html \
        munge-devel \
        munge-libs \
        numactl-devel \
        openssl \
        pam-devel  \
        perl-ExtUtils-MakeMaker \
        python \
        readline-devel \
        rrdtool-devel \
        wget
WORKDIR /workdir

# FIXME: where to host this?
COPY pmix-2.1.4-1.el7.x86_64.rpm .

RUN yum localinstall -y pmix-2.1.4-1.el7.x86_64.rpm
ARG SLURM_VERSION=18.08.6-2
RUN wget -q "https://download.schedmd.com/slurm/slurm-${SLURM_VERSION}.tar.bz2"
RUN echo "%_configure ./configure --enable-pam --without-shared-libslurm" >> /root/.rpmmacros
RUN rpmbuild -ta slurm*.tar.bz2
RUN mkdir -p /dist
RUN cp /root/rpmbuild/RPMS/x86_64/*.rpm /dist/
