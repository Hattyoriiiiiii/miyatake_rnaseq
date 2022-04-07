FROM ubuntu:20.04
LABEL maintainer "Tatsuya Hattori"

USER root
ENV DEBIAN_FRONTEND=noninteractive

##### Tools

# TRIMGALORE
ARG TRIMGALORE_VERSION=0.6.7
ARG TRIMGALORE_URL=https://github.com/FelixKrueger/TrimGalore/archive/refs/tags/${TRIMGALORE_VERSION}.tar.gz

# FASTP
ARG FASTP_VERSION=0.23.1
ARG FASTP_URL=http://opengene.org/fastp/fastp.${FASTP_VERSION}

# STAR
ARG STAR_VERSION=2.7.10a
ARG STAR_URL=https://github.com/alexdobin/STAR/archive/${STAR_VERSION}.tar.gz

# RSEM
ARG RSEM_VERSION=1.3.3
ARG RSEM_URL=https://github.com/deweylab/RSEM/archive/v${RSEM_VERSION}.tar.gz

# FASTQC
ARG FASTQC_VERSION=v0.11.9
ARG FASTQC_URL=http://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_${FASTQC_VERSION}.zip

# SAMTOOLS
ARG SAMTOOLS_VERSION=1.13
ARG SAMTOOLS_URL=https://github.com/samtools/samtools/releases/download/${SAMTOOLS_VERSION}/samtools-${SAMTOOLS_VERSION}.tar.bz2



RUN apt-get update && apt-get install -y \
    bash \
    bzip2 \
    curl \
    g++ \
    gcc \
    gfortran \
    git \
    grep \
    less \
    libbz2-dev \
    libcurl4-openssl-dev \
    liblzma-dev \
    libncurses5-dev \
    libreadline-dev \
    make \
    openjdk-8-jdk \
    pcre2-utils \
    python3 \
    tar \
    unzip \
    wget \
    xorg-dev \
    zlib1g-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN ln -s /usr/bin/python3 /usr/bin/python


### For trimming -----

# TrimGalore
WORKDIR /usr/local/src
RUN wget ${TRIMGALORE_URL} && \
    tar xzvf ${TRIMGALORE_VERSION}.tar.gz && \
    ln -s /usr/local/src/TrimGalore-${TRIMGALORE_VERSION}/trim_galore /usr/local/bin/

# fastp
WORKDIR /usr/local/bin
RUN wget http://opengene.org/fastp/fastp.${FASTP_VERSION} && \
    mv fastp.${FASTP_VERSION} fastp && \
    chmod a+x ./fastp

### For RNA-seq -----

# STAR
WORKDIR /usr/local/src
RUN wget ${STAR_URL} && \
    tar -xzf ${STAR_VERSION}.tar.gz && \
    cd STAR-${STAR_VERSION} && \
    ln -s /usr/local/src/STAR-${STAR_VERSION}/bin/Linux_x86_64_static/STAR /usr/local/bin/

# RSEM
WORKDIR /usr/local/src
RUN wget ${RSEM_URL} && \
    tar -zxvf v${RSEM_VERSION}.tar.gz && \
    cd RSEM-${RSEM_VERSION} && \
    make install

### Others -----
# FastQC
WORKDIR /usr/local/src
RUN wget ${FASTQC_URL} && \
    unzip fastqc_${FASTQC_VERSION}.zip && \
    mv FastQC FastQC_${FASTQC_VERSION} && \
    chmod +x FastQC_${FASTQC_VERSION}/fastqc && \
    ln -s /usr/local/src/FastQC_${FASTQC_VERSION}/fastqc /usr/local/bin/

# samtools
WORKDIR /usr/local/src
RUN wget ${SAMTOOLS_URL} && \
    tar jxvf samtools-${SAMTOOLS_VERSION}.tar.bz2 && \
    cd samtools-${SAMTOOLS_VERSION} && \
    ./configure && \
    make && \
    make install 


### For RNA-seq analysis -----
WORKDIR /usr/local/src
RUN wget https://sourceforge.net/projects/pcre/files/pcre2/10.37/pcre2-10.37.tar.gz && \
    tar xzvf pcre2-10.37.tar.gz && \
    cd pcre2-10.37 && \
    ./configure --prefix=/usr/local/src/pcre2-10.37 --enable-utf8 && \
    make && \
    make install

RUN apt-get update && apt-get install -y libpcre2-posix2 libpcre2-dev

WORKDIR /usr/local/src
RUN wget http://cran.ism.ac.jp/src/base/R-4/R-4.0.3.tar.gz && \
    tar xvf R-4.0.3.tar.gz && \
    cd R-4.0.3 && \
    ./configure --prefix=/usr/local/src/R-4.0.3 && \
    make && \
    ln -s /usr/local/src/R-4.0.3/bin/R /usr/local/bin/

# install required R packages
RUN R -e "install.packages('BiocManager', repos='https://cran.ism.ac.jp/')" 

# RNA-seq
RUN R -e "BiocManager::install(c('edgeR', 'DESeq2', 'limma', 'topGO', 'org.Mm.eg.db', 'ReactomePA', 'pathview', 'clusterProfiler'))"


# add user
ARG username=you
ARG wkdir=/home/${username}
RUN useradd -m ${username}
COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/bash"]

RUN chown -cR ${username}:${username} ${wkdir}
RUN mkdir -p /home/${username}/ref
RUN mkdir -p /home/${username}/index
RUN mkdir -p /home/${username}/work/data/rawdata

WORKDIR /home/${username}