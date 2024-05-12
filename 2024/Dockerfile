FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install Maya
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
    libglu1-mesa \
    libxkbcommon0 \
    libxinerama1 \
    libxmu6 \
    libxi6 \
    libjpeg62 \
    libnss3 \
    libxcomposite1 \
    libxdamage1 \
    libxrender1 \
    libxrandr2 \
    libxtst6 \
    libpci3 \
    libasound2 \
    && apt-get install libffi7 \
    && ln -s /usr/lib/x86_64-linux-gnu/libffi.so.7 /usr/lib/x86_64-linux-gnu/libffi.so.6

RUN wget -O libssl1.1.deb http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2_amd64.deb \
    && dpkg -i libssl1.1.deb \
    && rm libssl1.1.deb

RUN mkdir -p /usr/tmp && chmod 777 /usr/tmp \
    && mkdir -p ~/.cache/pip && chmod 777 ~/.cache/pip \
    && mkdir -p /usr/tmp/runtime-root && chmod 777 /usr/tmp/runtime-root

ENV XDG_RUNTIME_DIR=/usr/tmp/runtime-root

ENV PATH=/usr/autodesk/maya/bin:$PATH
