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
Ctrl_rep1,Con1CD8
Ctrl_rep2,Con4CD8
G_rep1,G2CD8
G_rep2,G3CD8
N_rep1,N2CD8
N_rep2,N3CD8
```

```
while read line
do
    data=
    ln -s ${before} ${after}
done < others/sample.txt
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

### 必要なデータのダウンロード

他の場面でも使用する可能性があるので、ローカルに保存しておきます。

```bash
mkdir -p ~/ref; cd $_
wget http://igenomes.illumina.com.s3-website-us-east-1.amazonaws.com/Mus_musculus/UCSC/mm10/Mus_musculus_UCSC_mm10.tar.gz && \
tar xvf Mus_musculus_UCSC_mm10.tar.gz

mkdir mm10
cp Mus_musculus/UCSC/mm10/Sequence/WholeGenomeFasta/genome.fa* ./mm10/
cp Mus_musculus/UCSC/mm10/Annotation/Genes/genes.gtf ./mm10/
```

<br>

### コンテナの作成

```
git clone https://github.com/Hattyoriiiiiii/miyatake_rnaseq.git
docker build -t hattyoriiiiiii/rna-seq:1.0 -f Dockerfile .
docker run \
    -it \
    --rm \
    --name test_rna \
    -v ${PWD}:/home/you/work \
    -v ${HOME}/ref/mm10:/home/you/ref \
    hattyoriiiiiii/rna-seq:1.0 \
    /bin/bash
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

mkproj ~/work; cd ~/work

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

mkproj ~/PROJECT_REPORTS; cd ~/PROJECT_REPORTS; ln -s ~/work/${projname}/REPORTS_${projname} REPORTS_${projname}

if type tree
then
    tree ~/work/${projname}
else
    pwd; find ~/work/${projname} | sort | sed '1d;s/^\.//;s/\/\([^/]*\)$/|--\1/;s/\/[^/|]*/|  /g'
fi

echo
```


<br>

## index の作成

STARでmappingするのに必要なindexを作成する。

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
#!/usr/bin/bash

OUT_PATH='./2_trim'

for sample in `ls ./data/seqs/*.fq.gz | \
                xargs basename -s .fq.gz | \
                cut -f 1,2 -d '_' | uniq `
do
echo ${sample}_1 ${sample}_2

fastp \
    -i ./data/seqs/${sample}_1.fq.gz \
    -I ./data/seqs/${sample}_2.fq.gz \
    -o ${OUT_PATH}/${sample}_1.fastp.fq.gz \
    -O ${OUT_PATH}/${sample}_2.fastp.fq.gz \
    -h ${OUT_PATH}/${sample}.html \
    -w 16 \
    -3 \
    -q 25 \
    --detect_adapter_for_pe

done

```

以下の通りに実行
`sh scripts/020_fastp.sh > log/020_fastp.log 2>&1 &`

<br>

## mapping
### 030_STAR_mapping.sh

```
#!/usr/bin/bash

for sample in `ls ./2_trim/*.fq.gz | \
                xargs basename -s .fq.gz | \
                cut -f 1,2 -d '_' | uniq `
do
STAR \
    --runMode alignReads \
    --runThreadN 16 \
    --outSAMtype BAM SortedByCoordinate \
    --quantMode TranscriptomeSAM GeneCounts \
    --genomeDir ~/indexes/STAR_mm10_index \
    --readFilesCommand gunzip -c \
    --readFilesIn \
        ./2_trim/${sample}_1.fastp.fq.gz \
        ./2_trim/${sample}_2.fastp.fq.gz \
    --outFileNamePrefix ./3_mapping/${sample}.
done
echo finished

```

以下の通りに実行
`sh scripts/030_STAR_mapping.sh > log/030_STAR_mapping.log 2>&1 &`

<br>

## 発現定量
### 040_RSEM.sh

```
#!/usr/bin/bash

for sample in `ls ./3_mapping/*.Aligned.toTranscriptome.out.bam | \
                xargs basename -s .Aligned.toTranscriptome.out.bam | \
                cut -f 1,2 -d '_' | uniq`
do
rsem-calculate-expression \
    --num-threads 16 \
    --alignments \
    --paired-end \
    --strandedness reverse \
    --bam \
    --no-bam-output \
    3_mapping/${sample}.Aligned.toTranscriptome.out.bam \
    ~/indexes/RSEM_reference/RSEM_reference \
    4_RSEM/${sample} 
done

```

以下の通りに実行
`sh scripts/040_RSEM.sh > log/040_RSEM.log 2>&1 &`

<br>

## リードカウント

### multimap (featureCounts)

```bash=

cd 3_mapping_smart;
featureCounts \
    -p \
    -s 2 \
    -T 16 \
    -t exon \
    -g gene_id \
    -M --fraction \
    -Q 12 \
    -a ~/ref/Mus_musculus/UCSC/mm10/Annotation/Genes/genes.gtf \
    -o ../5_featureCounts/counts.txt \
    34C_PS1.Aligned.sortedByCoord.out.bam \
    42C_PS1.Aligned.sortedByCoord.out.bam \
    34C_PS2.Aligned.sortedByCoord.out.bam \
    42C_PS2.Aligned.sortedByCoord.out.bam \
    34C_RS1.Aligned.sortedByCoord.out.bam \
    42C_RS1.Aligned.sortedByCoord.out.bam \
    34C_RS2.Aligned.sortedByCoord.out.bam \
    42C_RS2.Aligned.sortedByCoord.out.bam

```

以下の通りに実行
`sh scripts/050_count_multi.sh > log/050_count_multi.log 2>&1 &`

<br>

### multimap (RSEM)

```bash=
#!/usr/bin/bash
rsem-generate-data-matrix \
    4_RSEM_smart/34C_RS1.genes.results \
    4_RSEM_smart/34C_RS2.genes.results \
    4_RSEM_smart/42C_RS1.genes.results \
    4_RSEM_smart/42C_RS2.genes.results \
    > 5_rsem_counts/GeneExpressionMatrix_RS.tsv
```

以下の通りに実行
`sh scripts/050_count_rsem.sh > log/050_count_rsem.log 2>&1 &`


<br>

### edgeR

```
#!/usr/bin/Rscript

library(edgeR)

INPUT <- "5_rsem_counts/GeneExpressionMatrix_RS.tsv"
OUTPUT <- "6_diff/edgeR_rsem_res.txt"
# FIG_PATH <- 


data <- read.delim(INPUT, row.names=1, header=F, skip=1)
print(dim(data))
browser()

colnames(data) <- c("34C_RS1", "34C_RS2", "42C_RS1", "42C_RS2")
print(colnames(data)[1:4])
treatment <- factor(c(rep("34C_RS", 2), rep("42C_RS", 2)))
y <- DGEList(counts=data[, 1:4], group=treatment)


# differential expression
RunedgeR <- function(y, OUTPUT) {
    cpm <- cpm(y)
    keep <- rowSums(cpm > 1) >= 2
    y_expressed <- y[keep, ]
    y_norm <- calcNormFactors(y_expressed)
    d_com <- estimateCommonDisp(y_norm)
    d_mod <- estimateTagwiseDisp(d_com)
    out <- exactTest(d_mod)
    final <- topTags(out, n=nrow(out$table))

    write.table(final, file=OUTPUT, sep="\t", append=F, quote=F)
    return(final)
}


# plot heatmap
# pdf("analysis/figure/heatmap_rsem_RS.pdf", height=20)
# heatmap(y_expressed$counts, labCol=c("34C_RS1", "42C_RS1", "34C_RS2", "42C_RS2"))
# dev.off()

# Volcano plot
volcanoData <- cbind(final$table$logFC, -log10(final$table$FDR))
colnames(volcanoData) <- c("logFC", "-LogPval")
png("analysis/figure/volcano_rsem_RS.png")
plot(volcanoData, pch=19)
dev.off()


# limma
# library(limma)

# design <- model.matrix(~treatment)
# v <- voom(y_norm, design)
# vfit <- lmFit(v, design)
# efit <- eBayes(vfit)
# voom_res <- topTable(efit, coef=colnames(design)[ncol(design)], adjust.method="BH", sort.by="P", n=nrow(y$counts))
# write.table(voom_res, "6_diff/voom_res_rsem_RS.txt", sep="\t", append=F)

# # Volcano plot
# png("6_diff/volcanoplot_rsem_RS.png")
# volcanoplot(efit, coef=colnames(design)[ncol(design)], highlight=5, names=rownames(efit))
# dev.off()
```
