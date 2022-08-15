# List of Maya dependencies:
# https://help.autodesk.com/view/MAYAUL/2022/ENU/?guid=GUID-D2B5433C-E0D2-421B-9BD8-24FED217FD7F

# Figure out missing dependencies with this command:
# ldd /usr/autodesk/maya/lib/* 2> /dev/null | sed -nE 's/\s*(.+) => not found/\1/p' | sort --unique

# Potential Qt5 dependencies:
# https://wiki.qt.io/Qt5_dependencies

# Qt verbose mode:
# export QT_DEBUG_PLUGINS=1

FROM ubuntu:20.04

# Zero interaction with apt, accepts default answer for all questions.
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    # temporarly install 'software-properties-common' to add a repo
    && apt-get install -y --no-install-recommends software-properties-common \
    # libxp6 (maya dependency) is available in an archive PPA
    && add-apt-repository ppa:zeehio/libxp \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        # Utilities
        git \
        wget \
        # Installation dependencies
        build-essential \
        zlib1g-dev \
        # Maya dependencies
        xorg \
        libjpeg62 \
        libtiff5 \
        libxcb-xinerama0 \
        libgomp1 \
        libnss3 \
        libasound2 \
        libcurl4 \
        libgtk2.0-0 \
        libcggl \
        libncurses5 \
        liborc-0.4-0 \
        libxp6 \
        # Potential new libs to install for maya.
        # libpulse0
        # libpulse-mainloop-glib0
        # libxkbcommon-x11-0
        # libxcb-icccm4
        # libxcb-render-util0
        # libxcb-image0
        # libxcb-randr0
        # libxcb-keysyms1
        # libtbb2
    && add-apt-repository --remove ppa:zeehio/libxp \
    && apt-get purge -y software-properties-common

# Maya require ligpng15 and PySide2 libpng12, which are no longer available as a
# package. We have to download the sources and build them locally.
RUN wget -O libpng15.tgz https://sourceforge.net/projects/libpng/files/libpng15/older-releases/1.5.15/libpng-1.5.15.tar.gz \
    && tar -xvf libpng15.tgz \
    && rm libpng15.tgz \
    && cd libpng-1.5.15 \
    && ./configure --prefix=/usr/local/libpng \
    && make install \
    && cd ../ \
    && rm -r libpng-1.5.15 \
    && ln -s /usr/local/libpng/lib/libpng15.so.15 /usr/lib/libpng15.so.15

RUN wget -O libpng12.tgz  http://archive.ubuntu.com/ubuntu/pool/main/libp/libpng/libpng_1.2.54.orig.tar.xz \
    && tar -xvf libpng12.tgz \
    && rm libpng12.tgz \
    && cd libpng-1.2.54 \
    && ./autogen.sh \
    && ./configure \
    && make -j8  \
    && make install \
    && cd ../ \
    && rm -r libpng-1.2.54 \
    && ln -s /usr/local/lib/libpng12.so.0 /usr/lib/libpng12.so.0

# Uninstall 'make' dependencies
RUN apt-get purge -y build-essential zlib1g-dev

# Maya setup - - -

# Download, extract and install Maya
RUN apt-get install -y --no-install-recommends alien \
    && wget -O maya.tgz https://efulfillment.autodesk.com/NetSWDLD/2023/MAYA/5EC03A3E-DC11-3DF4-B675-4504BA04FF0C/ESD/Autodesk_Maya_2023_ML_Linux_64bit.tgz \
    && mkdir maya \
    && tar -xvf maya.tgz -C maya \
    && rm maya.tgz \
    && cd maya/Packages \
    && alien -cv Maya2023_64-2023.0-1319.x86_64.rpm \
    && dpkg -i *.deb \
    && cd ../../ \
    && rm -r maya \
    # Examples takes ~1G
    && rm -r /usr/autodesk/maya/Examples \
    && apt-get purge -y alien

# Install pip to mayapy
# NOTE: Since we prepended 'maya/bin' to PATH, the 'pip' is now the mayapy one.
RUN wget https://bootstrap.pypa.io/get-pip.py \
    && /usr/autodesk/maya/bin/mayapy get-pip.py

# Maya complain if /usr/tmp doesn't exists
RUN mkdir /usr/tmp && chmod 777 /usr/tmp

# Defines the base directory where non-essential runtime files and other file
# objects should be stored. Qt throw a warning at launch if not set.
RUN mkdir /var/tmp/runtime-root \
    && chmod 0700 /var/tmp/runtime-root
ENV XDG_RUNTIME_DIR=/var/tmp/runtime-root

ENV MAYA_LOCATION=/usr/autodesk/maya/
ENV PATH=$MAYA_LOCATION/bin:$PATH
ENV LIBQUICKTIME_PLUGIN_DIR=/usr/autodesk/maya/lib

# Cleanup unused packages, dependencies and cache
RUN apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Define home directory
ENV HOME="/root"
WORKDIR /root
