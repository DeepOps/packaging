FROM centos:7

# Install deps
RUN yum makecache fast \
    && yum install -y epel-release \
    && yum makecache fast \
    && yum groupinstall -y "Development Tools" \
    && yum install -y \
        munge-devel \
        munge-libs \
        readline-devel \
        openssl \
        openssl-devel \
        perl-ExtUtils-MakeMaker \
        mariadb-devel \
        mariadb-libs \
        pam-devel  \
        libcurl-devel \
        hwloc \
        lua \
        lua-devel \
        hwloc-devel \
        freeipmi-devel \
        numactl \
        numactl-devel \
        rrdtool-devel \
        ncurses-devel \
        libibmad \
        libibumad \
        man2html \
        python \
        ruby-devel \
        wget
RUN gem install --no-document fpm

ARG SLURM_VERSION=18.08.6-2

# Get source
WORKDIR /workdir
RUN wget -q -O slurm.tar.bz2 "https://download.schedmd.com/slurm/slurm-${SLURM_VERSION}.tar.bz2"
WORKDIR /workdir/src
RUN tar xjf ../slurm.tar.bz2 --strip-components=1

# Build
RUN mkdir -p /workdir/build/usr
RUN ./configure --prefix=/workdir/build/usr --sysconfdir=/etc/slurm --enable-pam --without-shared-libslurm
RUN make "-j$(nproc)"
RUN make contrib "-j$(nproc)"
RUN make install "-j$(nproc)"

# Copy pam_slurm lib
RUN cp /workdir/src/contribs/pam/.libs/pam_slurm.so /workdir/build/usr/lib/

# Copy other files
COPY files/ /workdir/build/

# Make package
WORKDIR /workdir
RUN fpm -s dir -t rpm -v "$SLURM_VERSION-centos7" -n slurm-nvidia \
        --conflicts slurm \
        -C /workdir/build .

# Copy deb to /dist/
RUN mkdir -p /dist
RUN cp *.rpm /dist/