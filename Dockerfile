FROM ubuntu:latest
RUN rm /bin/sh && ln -s /bin/bash /bin/sh
MAINTAINER Chris Plaisier <plaisier@asu.edu>
RUN apt-get update

# Get add-apt-repository function
RUN apt-get install --yes software-properties-common

# Ensure the latest version of R is installed
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 51716619E084DAB9
RUN add-apt-repository "deb [trusted=yes] https://cloud.r-project.org/bin/linux/ubuntu bionic-cran35/"
RUN apt-get update

# Fix issue with install wanting to be interactive
ENV DEBIAN_FRONTEND=noninteractive

# Instal main dependencies
RUN apt-get install --yes \
 build-essential \
 gcc-multilib \
 apt-utils \
 zlib1g-dev \
 vim-common \
 wget \
 python \
 python-pip \
 #git \
 pigz \
 #libxml2-dev \
 #liblzma-dev \
 #libncurses5-dev \
 #libncursesw5-dev \
 #libbz2-dev \
 #zlib1g-dev \
 autoconf \
 automake \
 #flex \
 #bison \
 #libcurl4-openssl-dev \
 #libssl-dev \
 #libssh2-1-dev \
 libtool \
 libgl1-mesa-glx \
 libegl1-mesa \
 libxrandr2 \
 libxrandr2 \
 libxss1 \
 libxcursor1 \
 libxcomposite1 \
 libasound2 \
 libxi6 \
 libxtst6

# Install additional python packages using pip
RUN pip install \
    numpy \
    scipy \
    cython \
    numba \
    matplotlib \
    seaborn \
    scikit-learn \
    h5py \
    click \
    pandas \
    biopython \
    sklearn
    reprotlab\
    forgi

# Install bowtie
RUN mkdir /install
WORKDIR /install
RUN wget https://downloads.sourceforge.net/project/bowtie-bio/bowtie/1.1.2/bowtie-1.1.2-linux-x86_64.zip
RUN unzip bowtie-1.1.2-linux-x86_64.zip
RUN ln -s bowtie-1.1.2/bowtie /usr/bin/bowtie

# Install SAMTOOLS
WORKDIR /tmp
RUN wget https://github.com/samtools/samtools/releases/download/1.10/samtools-1.5.tar.bz2
RUN tar -vxjf samtools-1.5.tar.bz2
WORKDIR /tmp/samtools-1.5
RUN autoheader
RUN autoconf -Wno-syntax
RUN ./configure
RUN make
RUN make install

# Install anaconda
RUN wget https://repo.anaconda.com/archive/Anaconda2-2019.10-Linux-x86_64.sh
RUN chmod +x Anaconda2-2019.10-Linux-x86_64.sh
RUN ./Anaconda2-2019.10-Linux-x86_64.sh

# Setup conda channels
RUN conda config --add channels defaults
RUN conda config --add channels conda-forge
RUN conda config --add channels bioconda

# Install miRge2.0
RUN conda install mirge
