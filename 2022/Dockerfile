FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install Maya
RUN apt-get update && apt-get install -y alien wget \
    && wget --no-check-certificate -O maya.tgz https://efulfillment.autodesk.com/NetSWDLD/2022/MAYA/7AA0A333-D72A-3C65-AB0F-0FE0F802014A/ESD/Autodesk_Maya_2022_ML_Linux_64bit.tgz \
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

RUN apt-get update \
    && apt-get install -y software-properties-common \
    && add-apt-repository -y ppa:zeehio/libxp || add-apt-repository -y ppa:zeehio/libxp \
    && apt-get update \
    && apt-get install -y libxp6 \
    && add-apt-repository --remove ppa:zeehio/libxp \
    && apt-get purge -y software-properties-common

RUN apt-get update && apt-get install -y \
    # Utils
    wget \
    git \
    # Maya requirements
    libgl1 \
    libxkbcommon0 \
    libglu1-mesa \
    libxinerama1 \
    libxmu6 \
    libxi6 \
    libjpeg62 \
    libnss3 \
    libxcomposite1 \
    libxdamage1 \
    libxrender1 \
    libxrandr2 \
    libxcursor1 \
    libxtst6 \
    libasound2 \
    libcg

# Install libssl.so.10 for Maya and Python
RUN apt-get update \
    && apt-get install -y alien \
    && wget -O libssl1.1.deb http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2_amd64.deb \
    && dpkg -i libssl1.1.deb \
    && rm libssl1.1.deb \
    && wget -O compat-openssl10.rpm http://mirror.centos.org/centos/8-stream/AppStream/x86_64/os/Packages/compat-openssl10-1.0.2o-4.el8.x86_64.rpm \
    && alien -cv compat-openssl10.rpm \
    && rm compat-openssl10.rpm \
    && dpkg -i compat-openssl10*.deb \
    && rm compat-openssl10*.deb \
    && ln -s /lib64/libssl.so.10 /lib/x86_64-linux-gnu/libssl.so.10 \
    && ln -s /lib64/libcrypto.so.10 /lib/x86_64-linux-gnu/libcrypto.so.10 \
    && apt-get purge -y alien

RUN wget -O libpng15.tgz https://sourceforge.net/projects/libpng/files/libpng15/older-releases/1.5.15/libpng-1.5.15.tar.gz \
    && tar -xvf libpng15.tgz \
    && rm libpng15.tgz \
    && cd libpng-1.5.15 \
    && apt-get install -y zlib1g-dev \
    && ./configure --prefix=/usr/local/libpng \
    && make install \
    && cd ../ \
    && rm -r libpng-1.5.15 \
    && ln -s /usr/local/libpng/lib/libpng15.so.15 /usr/lib/libpng15.so.15

RUN mkdir -p /usr/tmp && chmod 777 /usr/tmp \
    && mkdir -p ~/.cache/pip && chmod 777 ~/.cache/pip \
    && mkdir -p /usr/tmp/runtime-root && chmod 777 /usr/tmp/runtime-root

ENV XDG_RUNTIME_DIR=/usr/tmp/runtime-root

ENV PATH=/usr/autodesk/maya/bin:$PATH
