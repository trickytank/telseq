
FROM ubuntu:14.04
MAINTAINER Zhihao Ding <zhihao.ding@gmail.com>
LABEL Description="Telseq docker" Version="0.0.2"

VOLUME /tmp

WORKDIR /tmp

RUN apt-get update && \
    apt-get install -y \
        automake \
        autotools-dev \
        build-essential \
        cmake \
        libhts-dev \
        libhts0 \
        libjemalloc-dev \
        libsparsehash-dev \
        libz-dev \
        python-matplotlib \
        wget \
        zlib1g-dev

# build remaining dependencies:
# bamtools
RUN mkdir -p /deps && \
    cd /deps && \
    wget https://github.com/pezmaster31/bamtools/archive/v2.4.0.tar.gz && \
    tar -xzvf v2.4.0.tar.gz && \
    rm v2.4.0.tar.gz && \
    cd bamtools-2.4.0 && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make


# build telseq
ENV TELSEQ_VERSION="0.0.2"
RUN mkdir -p /src && \
    cd /src && \
    wget https://github.com/zd1/telseq/archive/v${TELSEQ_VERSION}.tar.gz && \
    tar -xzvf v${TELSEQ_VERSION}.tar.gz && \
    rm v${TELSEQ_VERSION}.tar.gz && \
    cd telseq-${TELSEQ_VERSION}/src && \
    ./autogen.sh && \
    ./configure --with-bamtools=/deps/bamtools-2.4.0 --prefix=/usr/local && \
    make && \
    make install


ENTRYPOINT ["/usr/local/bin/telseq"]
CMD ["--help"]
