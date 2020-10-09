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
 git \
 pigz \
 r-base \
 r-base-dev \
 libhdf5-dev \
 libxml2-dev \
 liblzma-dev \
 libncurses5-dev \
 libncursesw5-dev \
 libbz2-dev \
 zlib1g-dev \
 liblzma-dev \
 autoconf \
 automake \
 flex \
 bison \
 libcurl4-openssl-dev \
 libssl-dev \
 libssh2-1-dev \
 libtool

# Install additional python packages using pip3
RUN pip3 install \
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
    biopython

# Install HTSLIB
WORKDIR /tmp
RUN wget https://github.com/samtools/htslib/releases/download/1.10.2/htslib-1.10.2.tar.bz2
RUN tar -vxjf htslib-1.10.2.tar.bz2
WORKDIR /tmp/htslib-1.10.2
RUN autoheader
RUN autoconf
RUN ./configure
RUN make
RUN make install

# Install SAMTOOLS
WORKDIR /tmp
RUN wget https://github.com/samtools/samtools/releases/download/1.10/samtools-1.10.tar.bz2
RUN tar -vxjf samtools-1.10.tar.bz2
WORKDIR /tmp/samtools-1.10
RUN autoheader
RUN autoconf -Wno-syntax
RUN ./configure
RUN make
RUN make install

# Install scanpy
RUN pip3 install scanpy

# Install velocyto
RUN pip3 install velocyto

# Install scvelo
RUN pip3 install scvelo

# Install Seurat
RUN R -e "install.packages('BiocManager')"
RUN R -e "BiocManager::install('multtest')"
RUN R -e "install.packages(c('Seurat','ranger','plyr','dplyr','Matrix'))"

# Install loomR to convert Seurat to loom files
RUN apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libssh2-1-dev
RUN R -e "install.packages('devtools')"
RUN R -e "devtools::install_github('hhoeflin/hdf5r')"
RUN R -e "devtools::install_github('mojaveazure/loomR', ref = 'develop')"
RUN apt-get install -y python3-venv
RUN R -e "reticulate::py_install(packages ='umap-learn')"

# Install leidenalg for 
RUN pip3 install leidenalg

# Install mygene
RUN pip3 install mygene

# Install cluster analysis pacakge
RUN pip3 install clusim

# Install scVI
RUN pip3 install scVI

# Install umap-learn and tensorflow
RUN pip3 install umap-learn==0.3.9
RUN pip3 install tensorflow

# Install CONICSmat
RUN R -e "install.packages(c('beanplot','mixtools','pheatmap','zoo','squash'))"
RUN R -e "install.packages(c('XML'),repos='http://www.omegahat.net/R')"
RUN R -e "BiocManager::install('biomaRt','scran')"
RUN R -e "devtools::install_github('diazlab/CONICS/CONICSmat', dep=FALSE)"

# Install ccAF classifier
RUN pip3 install importlib_resources
RUN pip3 install ccAF
