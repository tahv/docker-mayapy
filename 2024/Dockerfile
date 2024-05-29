FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# maya 2024
RUN apt-get update && apt-get install -y alien wget \
    && wget --no-check-certificate -O maya.tgz https://efulfillment.autodesk.com/NetSWDLD/2024/MAYA/537B71D7-A391-3E25-93C3-9967181B3F34/ESD/Autodesk_Maya_2024_Linux_64bit.tgz \
    && mkdir maya \
    && tar -xvf maya.tgz -C maya \
    && rm maya.tgz \
    && cd maya/Packages \
    && alien -cv Maya2*.x86_64.rpm \
    && dpkg -i *.deb \
    && cd ../../ \
    && rm -r maya \
    && rm -r /usr/autodesk/maya/Examples \
    && ln -s /usr/autodesk/maya/bin/mayapy /usr/autodesk/maya/bin/python \
    && apt-get purge -y alien wget

# libxp6
RUN apt-get update \
    && apt-get install -y software-properties-common \
    && add-apt-repository -y ppa:zeehio/libxp || add-apt-repository -y ppa:zeehio/libxp \
    && apt-get update \
    && apt-get install -y libxp6 \
    && add-apt-repository --remove ppa:zeehio/libxp \
    && apt-get purge -y software-properties-common

# libpng15
RUN apt-get update \
    && apt-get install -y wget zlib1g-dev \
    && wget -O libpng15.tgz https://sourceforge.net/projects/libpng/files/libpng15/older-releases/1.5.15/libpng-1.5.15.tar.gz \
    && tar -xvf libpng15.tgz \
    && rm libpng15.tgz \
    && cd libpng-1.5.15 \
    && ./configure --prefix=/usr/local/libpng \
    && make install \
    && cd ../ \
    && rm -r libpng-1.5.15 \
    && ln -s /usr/local/libpng/lib/libpng15.so.15 /usr/lib/libpng15.so.15 \
    && apt-get purge -y wget zlib1g-dev

RUN apt-get update && apt-get install -y \
    # Utils
    wget \
    git \
    # Maya requirements
    libc6 \
    libsm6 \
    libice6 \
    zlib1g \
    openssl \
    libnss3 \
    dbus \
    lsb-core \
    libpcre16-3 \
    libglu1-mesa \
    libglw1-mesa \
    gamin \
    libaudiofile-dev \
    e2fsprogs \
    libcap2 \
    libdrm2 \
    libmng2 \
    flite \
    speech-dispatcher \
    cups \
    libxau6 \
    libxcomposite1 \
    libxcursor1 \
    libxext6 \
    libxfixes3 \
    libxi6 \
    libxmu6 \
    libxrandr2 \
    libxrender1 \
    libxss1 \
    libxshmfence1 \
    libxt6 \
    libxtst6 \
    libxinerama1 \
    libxcb1 \
    libxcb-util1 \
    libxcb-ewmh2 \
    libxcb-image0 \
    libxcb-keysyms1 \
    libxcb-render-util0 \
    libxkbcommon0 \
    libxkbcommon-x11-0 \
    libx11-6 \
    # Additional required packages for running Maya on Ubuntu
    libfam0 \
    libcurl4 \
    libjpeg62 \
    libxm4 \
    libgdbm-compat4 \
    libxcb-xinerama0 \
    libxdamage1

# libffi6
RUN wget -O libffi6.deb http://archive.ubuntu.com/ubuntu/pool/main/libf/libffi/libffi6_3.2.1-8_amd64.deb \
    && dpkg -i libffi6.deb \
    && rm libffi6.deb

# libssl
RUN wget -O libssl1.1.deb http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2_amd64.deb \
    && dpkg -i libssl1.1.deb \
    && rm libssl1.1.deb

RUN mkdir -p /usr/tmp && chmod 777 /usr/tmp \
    && mkdir -p ~/.cache/pip && chmod 777 ~/.cache/pip \
    && mkdir -p /usr/tmp/runtime-root && chmod 777 /usr/tmp/runtime-root

ENV XDG_RUNTIME_DIR=/usr/tmp/runtime-root
ENV PATH=/usr/autodesk/maya/bin:$PATH
ENV MAYA_NO_STANDALONE_ATEXIT=1
ENV MAYA_DISABLE_ADP=1
