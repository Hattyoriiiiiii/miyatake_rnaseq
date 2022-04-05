## 依頼内容

```
Con1 CD8; ctrl rep1
Con4 CD8; ctrl rep2
G2 CD8; G mutant rep1
G3 CD8; G mutant rep2
N2 CD8; N mutant rep1
N3 CD8; N mutant rep2
DEGについては、
ctrl vs G mutant
ctrl vs N mutant
で抽出してください
```

<br>

## データ・方向性の確認
### データ
- #### Sample
    - Ctrl
        - rep1 : `Con1CD8_[1,2].fq.gz`
        - rep2 : `Con4CD8_[1,2].fq.gz`
    - G mutant
        - rep1 : G2 CD8
        - rep2 : G3 CD8
    - N mutant
        - rep1 : N2 CD8
        - rep2 : N3 CD8
- #### ライブラリ
    - paired-end



#### データとファイルの対応関係 
- `factor_celltype_condition_replicate`で記載すると楽になる

- `sample.txt`

| sample_id | group | path |
| -------- | -------- | -------- |
| Ctrl_rep1     | Text     | Text     |
| Ctrl_rep2     | Text     | Text     |
| G_rep1     | Text     | Text     |
| G_rep2     | Text     | Text     |
| N_rep1     | Text     | Text     |
| N_rep2     | Text     | Text     |


```
Ctrl_rep1,
Ctrl_rep2,
G_rep1,
G_rep2,
N_rep1,
N_rep2
```





<br>

#### MD5は1つのファイルにまとめる
→ 全てのファイルに対してそれぞれのハッシュ値が生成された状態になっている。

<details><summary>詳細</summary>

```
drwxrwxr-x  2 hattori hattori 4096  4月  1 14:50  ./
drwx------ 53 hattori hattori 4096  4月  1 14:50  ../
-rw-rw-r--  1 hattori hattori   94  4月  1 14:50 'MD5(10).txt'
-rw-rw-r--  1 hattori hattori  100  4月  1 14:50 'MD5(11).txt'
-rw-rw-r--  1 hattori hattori   98  4月  1 14:50 'MD5(12).txt'
-rw-rw-r--  1 hattori hattori   96  4月  1 14:50 'MD5(13).txt'
-rw-rw-r--  1 hattori hattori   94  4月  1 14:50 'MD5(14).txt'
-rw-rw-r--  1 hattori hattori   96  4月  1 14:50 'MD5(15).txt'
-rw-rw-r--  1 hattori hattori  100  4月  1 14:50 'MD5(16).txt'
-rw-rw-r--  1 hattori hattori 2126  4月  1 14:50 'MD5(17).txt'
-rw-rw-r--  1 hattori hattori   94  4月  1 14:50 'MD5(2).txt'
-rw-rw-r--  1 hattori hattori   96  4月  1 14:50 'MD5(3).txt'
-rw-rw-r--  1 hattori hattori   96  4月  1 14:50 'MD5(4).txt'
-rw-rw-r--  1 hattori hattori   94  4月  1 14:50 'MD5(5).txt'
-rw-rw-r--  1 hattori hattori  100  4月  1 14:50 'MD5(6).txt'
-rw-rw-r--  1 hattori hattori   96  4月  1 14:50 'MD5(7).txt'
-rw-rw-r--  1 hattori hattori  100  4月  1 14:50 'MD5(8).txt'
-rw-rw-r--  1 hattori hattori   96  4月  1 14:50 'MD5(9).txt'
-rw-rw-r--  1 hattori hattori   96  4月  1 14:50  MD5.txt
```

</details>
    
<br>

→ 今回欲しいのは、必要なデータのみ。いらないファイル・データを避けて1つのファイルにまとめる。

```
$ for file in `ls`; do cat $file | grep CD8 | grep -v raw_data >> md5_check.txt; done
$ cat md5_check.txt 
a319ee50c69ddb2ccabed580b0c2b11c  G2CD8_1.fq.gz
c175b831cb7022a2873af651bf534f92  G2CD8_2.fq.gz
5bed625a5347de6c2a018902ef1a5bb3  G3CD8_1.fq.gz
280f562037001d29c4bb71c021bef51d  G3CD8_2.fq.gz
3bd3f6ad7543522c17428bfc305a7a5a  N2CD8_1.fq.gz
f73730d8118c3de409f3b2f15b079fff  N2CD8_2.fq.gz
ddf882af2249a3861339f7a77d2fb43b  Con1CD8_1.fq.gz
45b0c9f00870f36b11d6eca56628c85e  Con1CD8_2.fq.gz
7f889c8d661e7b15205b9cdef915e8de  Con4CD8_1.fq.gz
672db877aadfa9d2aee4a409ec226c36  Con4CD8_2.fq.gz
4676875cd304a9040874f6f88067819f  N3CD8_1.fq.gz
b52d6d417ba7077d4ae24db4741108df  N3CD8_2.fq.gz
```

![](https://i.imgur.com/FpOgO4L.png)

<br>

### Workflow

- Workflow_1
    - indexの作成
    - Read quality check (fastqc)
        - multiqc
    - Read trimming (fastp)
        - fastqc
        - multiqc
    - Mapping (STAR)
        - multiqc
    - Quantification (RSEM)
    - Differential expression anaylsis (edgeR)

### Environment
> macbook (pro or air), M1, 16 GB
- Docker
- Anaconda

<br>

## Envronment
### Install Docker Desktop on Mac

下記のdocsに従う。
https://docs.docker.com/desktop/mac/install/

<br>

### aa

```Dockerfile
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
ARG username=hattori
ARG wkdir=/home/${username}
RUN useradd -m ${username}
COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/bash"]

RUN chown -cR ${username}:${username} ${wkdir}
RUN mkdir -p /home/${username}/genome
WORKDIR /home/${username}
```

### `entrypoint.sh`

```
#!/bin/bash

export USER=you
export HOME=/home/$USER

uid=$(stat -c "%u" .)
gid=$(stat -c "%g" .)

if [ "$uid" -ne 0 ]; then
    if [ "$(id -g $USER)" -ne $gid ]; then
        getent group $gid >/dev/null 2>&1 || groupmod -g $gid $USER
        chgrp -R $gid $HOME
    fi
    if [ "$(id -u $USER)" -ne $uid ]; then
        usermod -u $uid $USER
    fi
fi

exec setpriv --reuid=$USER --regid=$USER --init-groups "$@"
```

<br>

### コンテナの作成

```
docker build -t rna-seq:1.0 -f Dockerfile .
docker run \
    -it \
    --rm \
    --user root \
```

<br>

## Settings (RNA-seq用プロジェクトのディレクトリ)

```bash
#!/bin/bash

########## <<< functions >>> ##########

function mkproj()
{
    if [ ! -d "$@"} ]; then
        printf "\n Making a directory named \"${@}\" \n"
        mkdir -p "$@"
    else
        printf "\n There is already a directory named \"${@}\" \n"
    fi
}


########## <<< config >>> ##########

DIR=(data log others summary scripts QualityAssessment 01_qc/{before/multiqc_before,after/multiqc_after} 02_trim 03_align 04_RSEM 05_rsem_counts 06_diff 07_topgo 08_reactomepa notebooks/{data,figures})
LINK=(01_qc/before/multiqc_before 01_qc/after/multiqc_after others scripts summary log notebooks QualityAssessment)

########## Making directories ##########

printf "\n <<< Type project name (e.g. RNA_Stra8) >>> \n\n"
read projname

mkproj ~/project; cd ~/project

if [ ! -d ${projname} ]
then
    printf "\n ---> Making a directory named \"$projname\" \n"
    printf "\n <<< ----- Initialization ----- >>> \n\n"
    mkdir -p ${projname}
else
    printf "\n ---> There is already a directory named \"$projname\"\n\n"
fi


cd ${projname}
for directory in "${DIR[@]}"; do
    mkproj ${directory}
done

# For proccesing
touch README.md others/{sample.txt,rename.sh,rename.csv,SRR_Acc_List.txt}


########## make symbolic link ##########
mkproj REPORTS_${projname}; cd REPORTS_${projname}

for path in "${LINK[@]}"; do
    basename=`echo ${path} | xargs basename`
    ln -s ../${path} ${basename}
done

mkproj ~/PROJECT_REPORTS; cd ~/PROJECT_REPORTS; ln -s ~/project/${projname}/REPORTS_${projname} REPORTS_${projname}

if type tree
then
    tree ~/project/${projname}
else
    pwd; find ~/project/${projname} | sort | sed '1d;s/^\.//;s/\/\([^/]*\)$/|--\1/;s/\/[^/|]*/|  /g'
fi

echo
```


<br>

## index の作成

STARでmappingするのに必要なindexを作成する。

### 必要なデータのダウンロード

```bash
wget http://igenomes.illumina.com.s3-website-us-east-1.amazonaws.com/Mus_musculus/UCSC/mm10/Mus_musculus_UCSC_mm10.tar.gz && \
tar xvf Mus_musculus_UCSC_mm10.tar.gz
```


### STAR indexの作成
```bash=
#!/usr/bin/bash

STAR \
    --runThreadN 16 \
    --runMode genomeGenerate \
    --genomeDir ~/indexes/ \
    --genomeFastaFiles ~/ref/Mus_musculus/UCSC/mm10/Sequence/WholeGenomeFasta/genome.fa \
    --sjdbGTFfile ~/ref/Mus_musculus/UCSC/mm10/Annotation/Genes/genes.gtf
```


### RSEM indexの作成
```bash=
mkdir -p ~/indexes/RSEM_reference
~/src/RSEM-1.3.3/rsem-prepare-reference \
    --num-threads 16 \
    --gtf ~/ref/Mus_musculus/UCSC/mm10/Annotation/Genes/genes.gtf \
    ~/ref/Mus_musculus/UCSC/mm10/Sequence/WholeGenomeFasta/genome.fa \
    ~/indexes/RSEM_reference/RSEM_reference
```

<br>

## Assessing Read Quality
### 010_fastqc.sh

```

```

以下の通りに実行
`sh scripts/010_fastqc.sh > log/010_fastqc.log 2>&1 &`

<br>

## Read trimming

### 020_fastp.sh

```

```

以下の通りに実行
`sh scripts/020_fastp.sh > log/020_fastp.log 2>&1 &`

<br>

## mapping
### 030_STAR_mapping.sh

```

```

以下の通りに実行
`sh scripts/030_STAR_mapping.sh > log/030_STAR_mapping.log 2>&1 &`

<br>

## 発現定量
### 040_RSEM.sh

```

```

以下の通りに実行
`sh scripts/040_RSEM.sh > log/040_RSEM.log 2>&1 &`

<br>

## リードカウント

### multimap (featureCounts)

```bash=

```

以下の通りに実行
`sh scripts/050_count_multi.sh > log/050_count_multi.log 2>&1 &`

<br>

### multimap (RSEM)

```bash=

```

以下の通りに実行
`sh scripts/050_count_rsem.sh > log/050_count_rsem.log 2>&1 &`


