FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install Maya
RUN apt-get update && apt-get install -y alien wget \
    && wget --no-check-certificate -O maya.tgz https://efulfillment.autodesk.com/NetSWDLD/2025/MAYA/1AAEB4DA-FE7D-3C8A-A4F4-C217F55C55BA/ESD/Autodesk_Maya_2025_Linux_64bit.tgz \
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
    libopengl0 \
    libfreetype6 \
    libxkbcommon0 \
    libglu1-mesa \
    libtiff5 \
    libfontconfig1 \
    libxinerama1 \
    libxmu6 \
    libxpm4 \
    libxi6 \
    libjpeg62 \
    libegl1 \
    libnss3 \
    libxcomposite1 \
    libxdamage1 \
    libxrender1 \
    libxrandr2 \
    libxtst6 \
    libpci3 \
    libasound2 \
    libxkbfile1 \
    libcg

RUN wget -O libssl1.1.deb http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2_amd64.deb \
    && dpkg -i libssl1.1.deb \
    && rm libssl1.1.deb

RUN mkdir -p /usr/tmp && chmod 777 /usr/tmp \
    && mkdir -p ~/.cache/pip && chmod 777 ~/.cache/pip

ENV PATH=/usr/autodesk/maya/bin:$PATH
