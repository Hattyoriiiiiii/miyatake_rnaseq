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
        - rep1 : Con1 CD8
        - rep2 : Con4 CD8
    - G mutant
        - rep1 : G2 CD8
        - rep2 : G3 CD8
    - N mutant
        - rep1 : N2 CD8
        - rep2 : N3 CD8
- #### ライブラリ
    - paired-end



### 構造

#### 処理前

```
miyatake_rnaseq
├── Dockerfile
├── README.md
├── entrypoint.sh
├── mkproj.sh
├── others
│   ├── group.csv
│   ├── sample.csv
│   └── sample.txt
└── scripts
    ├── 010_fastqc.sh
    ├── 020_fastp.sh
    ├── 030_STAR_mapping.sh
    ├── 040_RSEM.sh
    ├── 050_count_rsem.sh
    └── 060_edger.R
```

#### 処理後

<details><summary>詳細</summary>

<br>

```
miyatake_rnaseq/
├── 01_qc
│   ├── after
│   │   └── multiqc_after
│   └── before
│       ├── Ctrl_rep1_1_fastqc.zip
│       ├── Ctrl_rep1_2_fastqc.zip
│       ├── Ctrl_rep2_1_fastqc.zip
│       ├── Ctrl_rep2_2_fastqc.zip
│       ├── G_rep1_1_fastqc.zip
│       ├── G_rep1_2_fastqc.zip
│       ├── G_rep2_1_fastqc.zip
│       ├── G_rep2_2_fastqc.zip
│       ├── N_rep1_1_fastqc.zip
│       ├── N_rep1_2_fastqc.zip
│       ├── N_rep2_1_fastqc.zip
│       ├── N_rep2_2_fastqc.zip
│       └── multiqc_before
│           ├── Ctrl_rep1_1_fastqc.html
│           ├── Ctrl_rep1_2_fastqc.html
│           ├── Ctrl_rep2_1_fastqc.html
│           ├── Ctrl_rep2_2_fastqc.html
│           ├── G_rep1_1_fastqc.html
│           ├── G_rep1_2_fastqc.html
│           ├── G_rep2_1_fastqc.html
│           ├── G_rep2_2_fastqc.html
│           ├── N_rep1_1_fastqc.html
│           ├── N_rep1_2_fastqc.html
│           ├── N_rep2_1_fastqc.html
│           ├── N_rep2_2_fastqc.html
│           ├── multiqc_data
│           │   ├── multiqc.log
│           │   ├── multiqc_data.json
│           │   ├── multiqc_fastqc.txt
│           │   ├── multiqc_general_stats.txt
│           │   └── multiqc_sources.txt
│           └── multiqc_report.html
├── 02_trim
│   ├── Ctrl_rep1_1.fastp.fastq.gz
│   ├── Ctrl_rep1_2.fastp.fastq.gz
│   ├── Ctrl_rep2_1.fastp.fastq.gz
│   ├── Ctrl_rep2_2.fastp.fastq.gz
│   ├── G_rep1_1.fastp.fastq.gz
│   ├── G_rep1_2.fastp.fastq.gz
│   ├── G_rep2_1.fastp.fastq.gz
│   ├── G_rep2_2.fastp.fastq.gz
│   ├── N_rep1_1.fastp.fastq.gz
│   ├── N_rep1_2.fastp.fastq.gz
│   ├── N_rep2_1.fastp.fastq.gz
│   └── N_rep2_2.fastp.fastq.gz
├── 03_align
│   ├── Ctrl_rep1.Aligned.sortedByCoord.out.bam
│   ├── Ctrl_rep1.Aligned.toTranscriptome.out.bam
│   ├── Ctrl_rep1.Log.final.out
│   ├── Ctrl_rep1.Log.out
│   ├── Ctrl_rep1.Log.progress.out
│   ├── Ctrl_rep1.ReadsPerGene.out.tab
│   ├── Ctrl_rep1.SJ.out.tab
│   ├── Ctrl_rep2.Aligned.sortedByCoord.out.bam
│   ├── Ctrl_rep2.Aligned.toTranscriptome.out.bam
│   ├── Ctrl_rep2.Log.final.out
│   ├── Ctrl_rep2.Log.out
│   ├── Ctrl_rep2.Log.progress.out
│   ├── Ctrl_rep2.ReadsPerGene.out.tab
│   ├── Ctrl_rep2.SJ.out.tab
│   ├── G_rep1.Aligned.sortedByCoord.out.bam
│   ├── G_rep1.Aligned.toTranscriptome.out.bam
│   ├── G_rep1.Log.final.out
│   ├── G_rep1.Log.out
│   ├── G_rep1.Log.progress.out
│   ├── G_rep1.ReadsPerGene.out.tab
│   ├── G_rep1.SJ.out.tab
│   ├── G_rep2.Aligned.sortedByCoord.out.bam
│   ├── G_rep2.Aligned.toTranscriptome.out.bam
│   ├── G_rep2.Log.final.out
│   ├── G_rep2.Log.out
│   ├── G_rep2.Log.progress.out
│   ├── G_rep2.ReadsPerGene.out.tab
│   ├── G_rep2.SJ.out.tab
│   ├── N_rep1.Aligned.sortedByCoord.out.bam
│   ├── N_rep1.Aligned.toTranscriptome.out.bam
│   ├── N_rep1.Log.final.out
│   ├── N_rep1.Log.out
│   ├── N_rep1.Log.progress.out
│   ├── N_rep1.ReadsPerGene.out.tab
│   ├── N_rep1.SJ.out.tab
│   ├── N_rep2.Aligned.sortedByCoord.out.bam
│   ├── N_rep2.Aligned.toTranscriptome.out.bam
│   ├── N_rep2.Log.final.out
│   ├── N_rep2.Log.out
│   ├── N_rep2.Log.progress.out
│   ├── N_rep2.ReadsPerGene.out.tab
│   └── N_rep2.SJ.out.tab
├── 04_RSEM
│   ├── Ctrl_rep1.genes.results
│   ├── Ctrl_rep1.isoforms.results
│   ├── Ctrl_rep1.stat
│   │   ├── Ctrl_rep1.cnt
│   │   ├── Ctrl_rep1.model
│   │   └── Ctrl_rep1.theta
│   ├── Ctrl_rep2.genes.results
│   ├── Ctrl_rep2.isoforms.results
│   ├── Ctrl_rep2.stat
│   │   ├── Ctrl_rep2.cnt
│   │   ├── Ctrl_rep2.model
│   │   └── Ctrl_rep2.theta
│   ├── G_rep1.genes.results
│   ├── G_rep1.isoforms.results
│   ├── G_rep1.stat
│   │   ├── G_rep1.cnt
│   │   ├── G_rep1.model
│   │   └── G_rep1.theta
│   ├── G_rep2.genes.results
│   ├── G_rep2.isoforms.results
│   ├── G_rep2.stat
│   │   ├── G_rep2.cnt
│   │   ├── G_rep2.model
│   │   └── G_rep2.theta
│   ├── N_rep1.genes.results
│   ├── N_rep1.isoforms.results
│   ├── N_rep1.stat
│   │   ├── N_rep1.cnt
│   │   ├── N_rep1.model
│   │   └── N_rep1.theta
│   ├── N_rep2.genes.results
│   ├── N_rep2.isoforms.results
│   └── N_rep2.stat
│       ├── N_rep2.cnt
│       ├── N_rep2.model
│       └── N_rep2.theta
├── 05_rsem_counts
│   └── GeneExpressionMatrix.tsv
├── 06_diff
│   ├── Ctrl_vs_G_mut
│   │   └── Ctrl_vs_G_mut.txt
│   ├── Ctrl_vs_N_mut
│   │   └── Ctrl_vs_N_mut.txt
│   └── G_mut_vs_N_mut
│       └── G_mut_vs_N_mut.txt
├── 07_topgo
├── 08_reactomepa
├── Dockerfile
├── QualityAssessment
├── README.md
├── REPORTS_RNA_Miyatake
│   ├── QualityAssessment -> ../QualityAssessment
│   ├── log -> ../log
│   ├── multiqc_after -> ../01_qc/after/multiqc_after
│   ├── multiqc_before -> ../01_qc/before/multiqc_before
│   ├── notebooks -> ../notebooks
│   ├── others -> ../others
│   ├── scripts -> ../scripts
│   └── summary -> ../summary
├── data
│   ├── Ctrl_rep1_1.fastq.gz -> rawdata/Con1CD8_1.fq.gz
│   ├── Ctrl_rep1_2.fastq.gz -> rawdata/Con1CD8_2.fq.gz
│   ├── Ctrl_rep2_1.fastq.gz -> rawdata/Con4CD8_1.fq.gz
│   ├── Ctrl_rep2_2.fastq.gz -> rawdata/Con4CD8_2.fq.gz
│   ├── G_rep1_1.fastq.gz -> rawdata/G2CD8_1.fq.gz
│   ├── G_rep1_2.fastq.gz -> rawdata/G2CD8_2.fq.gz
│   ├── G_rep2_1.fastq.gz -> rawdata/G3CD8_1.fq.gz
│   ├── G_rep2_2.fastq.gz -> rawdata/G3CD8_2.fq.gz
│   ├── N_rep1_1.fastq.gz -> rawdata/N2CD8_1.fq.gz
│   ├── N_rep1_2.fastq.gz -> rawdata/N2CD8_2.fq.gz
│   ├── N_rep2_1.fastq.gz -> rawdata/N3CD8_1.fq.gz
│   ├── N_rep2_2.fastq.gz -> rawdata/N3CD8_2.fq.gz
│   └── rawdata
│       ├── Con1CD8_1.fq.gz
│       ├── Con1CD8_2.fq.gz
│       ├── Con4CD8_1.fq.gz
│       ├── Con4CD8_2.fq.gz
│       ├── G2CD8_1.fq.gz
│       ├── G2CD8_2.fq.gz
│       ├── G3CD8_1.fq.gz
│       ├── G3CD8_2.fq.gz
│       ├── N2CD8_1.fq.gz
│       ├── N2CD8_2.fq.gz
│       ├── N3CD8_1.fq.gz
│       └── N3CD8_2.fq.gz
├── entrypoint.sh
├── log
│   ├── 010_fastqc.log
│   ├── 020_fastp.log
│   ├── 030_STAR_mapping.log
│   ├── 040_RSEM.log
│   └── 050_count_rsem.log
├── mkproj.sh
├── notebooks
│   ├── data
│   └── figures
├── others
│   ├── group.csv
│   ├── sample.csv
│   └── sample.txt
├── scripts
│   ├── 010_fastqc.sh
│   ├── 020_fastp.sh
│   ├── 030_STAR_mapping.sh
│   ├── 040_RSEM.sh
│   ├── 050_count_rsem.sh
│   ├── 060_edger.R
│   └── test_edgeR.R
└── summary
```

<br>

</details>

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

```
you@56a62152097b:~/work/data$ md5sum -c md5_check.txt 
G2CD8_1.fq.gz: OK
G2CD8_2.fq.gz: OK
G3CD8_1.fq.gz: OK
G3CD8_2.fq.gz: OK
N2CD8_1.fq.gz: OK
N2CD8_2.fq.gz: OK
Con1CD8_1.fq.gz: OK
Con1CD8_2.fq.gz: OK
Con4CD8_1.fq.gz: OK
Con4CD8_2.fq.gz: OK
N3CD8_1.fq.gz: OK
N3CD8_2.fq.gz: OK
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

<br>

## Envronment
### Install Docker Desktop on Mac

下記のdocsに従う。
https://docs.docker.com/desktop/mac/install/

<br>

### 必要なデータのダウンロード

他の場面でも使用する可能性があるので、ローカルに保存しておきます。

```bash
mkdir -p ~/ref; cd $_
wget http://igenomes.illumina.com.s3-website-us-east-1.amazonaws.com/Mus_musculus/UCSC/mm10/Mus_musculus_UCSC_mm10.tar.gz && \
tar xvf Mus_musculus_UCSC_mm10.tar.gz
```

<br>

### コンテナの作成

```
git clone https://github.com/Hattyoriiiiiii/miyatake_rnaseq.git
cd miyatake_rnaseq
```

- buildにはそこそこ時間がかかります。

```
# こちらは実行しない
# docker build -t hattyoriiiiiii/rna-seq:1.0 -f Dockerfile .
```

- 今回は自分が作成した環境を`pull`します。
- `Dockerfile`を作成して`build`すると作成できます。

```
docker pull hattyoriiiiiii/rna-seq:1.0
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

ここ以降は、コンテナ内での作業になります。

<br>

### ディレクトリの作成

```
./mkproj.sh
```

### サンプル名の変更

- `vi others/sample.csv`でファイル作成。
    - `i`でインサートモードに入って以下を記入。
    - 記入が終わったら`esc`キーを押して、続けて`:wq`と入力する。

```others/sample.csv
Con1CD8,Ctrl_rep1,Ctrl
Con4CD8,Ctrl_rep2,Ctrl
G2CD8,G_rep1,G_mut
G3CD8,G_rep2,G_mut
N2CD8,N_rep1,N_mut
N3CD8,N_rep2,N_mut

```

<br>

- シンボリックリンクを作成する。
    - rawdataのファイル名を変更せずに利用するため。

```bash
while IFS=, read before after condition; do
    echo "${before}.fq.gz --> ${after}.fastq.gz : ${condition}"
    ln -s  rawdata/${before}_1.fq.gz data/${after}_1.fastq.gz
    ln -s  rawdata/${before}_2.fq.gz data/${after}_2.fastq.gz
done < others/sample.csv
```

<br>

```
cut -d "," -f 2 others/sample.csv > others/sample.txt
```



<br>

## index の作成

STARでmappingするのに必要なindexを作成する。

### STAR indexの作成
```bash=
#!/usr/bin/bash

mkdir -p ~/index
STAR \
    --runThreadN 4 \
    --runMode genomeGenerate \
    --genomeDir ~/index \
    --genomeFastaFiles ~/ref/genome.fa \
    --sjdbGTFfile ~/ref/genes.gtf
```

- 基本的なオプションについて
    - `--runThreadN`: NumberOfThreads
    - `--runMode`: genomeGenerate (indexの作成を行う)
    - `--genomeDir`: /path/to/genomeDir
    - `--genomeFastaFiles`: `/path/to/genome/fasta1 /path/to/genome/fasta2`
    - `--sjdbGTFfile`: `/path/to/annotations.gtf`
    - `--sjdbOverhang`: `ReadLength-1`

<br>

### RSEM indexの作成
```bash=
mkdir -p ~/index/RSEM_reference
rsem-prepare-reference \
    --num-threads 4 \
    --gtf ~/ref/genes.gtf \
    ~/ref/genome.fa \
    ~/index/RSEM_reference/RSEM_reference
```

- 基本的なオプションについて


<br>

## Tips (繰り返し処理)

- シェルスクリプトを作成する理由の1つとして、主に複数サンプルに対して同じ処理をしたいときがあります。そこで2つの処理方法を紹介します。
    1. 別で繰り返し処理したいサンプルを明記して処理する
        - 簡単
        - human errorが生じる可能性
    2. ファイル名をもとにサンプルを取得して処理する
        - 少し知識が必要
        - サンプル数がかなり多くても楽にできる

これらで取得したサンプル名を引数として、処理を行なっていきます。どのような文字列が返ってきているのかを`echo`コマンドを用いて確認してみます。

<br>

### (1) の方法
先ほど作成した`others/sample.txt`は、以下のようになっています。

- 最も簡単な方法だと思います。
- サンプル数が多くないため、こちらの方法で進めていきます。

```others/sample.txt
Ctrl_rep1
Ctrl_rep2
G_rep1
G_rep2
N_rep1
N_rep2

```

<br>

### (2) の方法

- 以下の方法は、ある程度詳しくないとできません。ですが、出来るようになるとサンプル数がかなり多くなっても対応できる点で優れていると思います。

```
for sample in `ls ./data/rawdata/*.fq.gz | \
               xargs basename -s .fq.gz | \
               cut -f 1 -d '_' | uniq`
do 
    echo "${sample}"
done
```

- `ls ./data/rawdata/*.fq.gz | xargs basename -s .fq.gz | cut -f 1 -d '_' | uniq`
    - `ls`, `xargs`, `cut`, `uniq`という4つのコマンドを使って、それぞれの出力をパイプ(`|`)でつなげています。
    - ファイルの命名規則を定めることが最も望ましいですが、頂くデータの名前は様々ですので、`echo`コマンドや`wc`コマンドなどで必要なサンプル名が取れているかを確認します。

以下が出力になります。

```
Con1CD8
Con4CD8
G2CD8
G3CD8
N2CD8
N3CD8
```

<br>

- 以下に、比較として元のファイル名を示します。
- `data/rawdata`というディレクトリから、`.fq.gz`という拡張子と、paired-end readsのforwardとreverseを表す`_1`, `_2`の部分が除去されてサンプル名のみが取得できていることが確認できました。

```
% ls -lh data/rawdata 
total 26100480
-rw-r--r--@ 1 hattori  staff   814M  4  6 22:02 Con1CD8_1.fq.gz
-rw-r--r--@ 1 hattori  staff   840M  4  7 12:03 Con1CD8_2.fq.gz
-rw-r--r--@ 1 hattori  staff   1.0G  4  7 12:06 Con4CD8_1.fq.gz
-rw-r--r--@ 1 hattori  staff   1.0G  4  7 12:11 Con4CD8_2.fq.gz
-rw-r--r--@ 1 hattori  staff   1.1G  4  7 12:13 G2CD8_1.fq.gz
-rw-r--r--@ 1 hattori  staff   1.2G  4  7 12:12 G2CD8_2.fq.gz
-rw-r--r--@ 1 hattori  staff   1.1G  4  7 12:12 G3CD8_1.fq.gz
-rw-r--r--@ 1 hattori  staff   1.1G  4  7 12:13 G3CD8_2.fq.gz
-rw-r--r--@ 1 hattori  staff   1.1G  4  7 12:13 N2CD8_1.fq.gz
-rw-r--r--@ 1 hattori  staff   1.2G  4  7 12:13 N2CD8_2.fq.gz
-rw-r--r--@ 1 hattori  staff   1.0G  4  7 12:12 N3CD8_1.fq.gz
-rw-r--r--@ 1 hattori  staff   1.0G  4  7 12:12 N3CD8_2.fq.gz
```

<br>

## Assessing Read Quality
- リードクオリティの確認を行う。
### 010_fastqc.sh

```010_fastqc.sh
#!/usr/bin/bash
# usage : scripts/010_fastqc.sh > log/010_fastqc.log 2>&1 &

############## config ##############

exp="fastp"
cores=4

OUTDIR_FASTQC_BEFORE='01_qc/before'
REPODIR_FASTQC_BEFORE='01_qc/before/multiqc_before'

if [ ! -d ${OUTDIR_FASTQC_BEFORE} ]; then mkdir -p ${OUTDIR_FASTQC_BEFORE}; fi
if [ ! -d ${REPODIR_FASTQC_BEFORE} ]; then mkdir -p ${REPODIR_FASTQC_BEFORE}; fi


############## FastQC - Before trimming ##############

fastqc \
    -t ${cores} \
    --nogroup \
    -f fastq \
    data/*.fastq.gz \
    -o ${OUTDIR_FASTQC_BEFORE}

multiqc ${OUTDIR_FASTQC_BEFORE} -o ${REPODIR_FASTQC_BEFORE}
mv ${OUTDIR_FASTQC_BEFORE}/*.html ${REPODIR_FASTQC_BEFORE}/

```

以下の通りに実行
`sh scripts/010_fastqc.sh > log/010_fastqc.log 2>&1 &`

<br>

## Read trimming
- 低品質なリード、アダプターの除去を行う。
### 020_fastp.sh

```
#!/usr/bin/bash
# usage : sh scripts/020_fastp.sh > log/020_fastp.log 2>&1 &

exp='fastp'
OUT_PATH='./02_trim'
REPODIR_TRIM='${OUT_PATH}/${exp}'

while read sample; do
echo ${sample}_1 ${sample}_2
fastp \
    -i ./data/${sample}_1.fastq.gz \
    -I ./data/${sample}_2.fastq.gz \
    -o ${OUT_PATH}/${sample}_1.fastp.fastq.gz \
    -O ${OUT_PATH}/${sample}_2.fastp.fastq.gz \
    -h ${REPODIR_TRIM}/${sample}.html \
    -j ${REPODIR_TRIM}/${sample}.json \
    -w 16 \
    -3 \
    -q 25 \
    --detect_adapter_for_pe
done < others/sample.txt


multiqc ${REPODIR_TRIM} -o ${REPODIR_TRIM}
```

以下の通りに実行
`sh scripts/020_fastp.sh > log/020_fastp.log 2>&1 &`

<br>

## mapping
- リファレンスゲノムに対して、得られたリードのアラインメントを行う。
### 030_STAR_mapping.sh

```
#!/bin/bash
# usage : sh scripts/030_STAR_mapping.sh > log/030_STAR_mapping.log 2>&1 &

while read sample; do
STAR \
    --runMode alignReads \
    --runThreadN 16 \
    --outSAMtype BAM SortedByCoordinate \
    --quantMode TranscriptomeSAM GeneCounts \
    --genomeDir ~/indexes/STAR_mm10_index \
    --readFilesCommand gunzip -c \
    --readFilesIn \
        ./02_trim/${sample}_1.fastp.fastq.gz \
        ./02_trim/${sample}_2.fastp.fastq.gz \
    --outFileNamePrefix ./03_align/${sample}.
done < others/sample.txt
echo finished

```

以下の通りに実行
`sh scripts/030_STAR_mapping.sh > log/030_STAR_mapping.log 2>&1 &`

<br>

## 発現定量

- 定量値を取得する。

### 040_RSEM.sh

```
#!/usr/bin/bash
# usage : scripts/040_RSEM.sh > log/040_RSEM.log 2>&1 &

while read sample; do
rsem-calculate-expression \
    --num-threads 16 \
    --alignments \
    --paired-end \
    --strandedness none \
    --bam \
    --no-bam-output \
    3_mapping/${sample}.Aligned.toTranscriptome.out.bam \
    ~/indexes/RSEM_reference/RSEM_reference \
    4_RSEM/${sample} 
done < others/sample.txt

```

- strandedのkitを利用した場合、`--strandness reverse`に変更する。

以下の通りに実行
`sh scripts/040_RSEM.sh > log/040_RSEM.log 2>&1 &`

<br>

## リードカウント

### RSEM

- リードカウントの行列データ(matrix)の作成を行う。

```050_count_rsem.sh
#!/usr/bin/bash
# usage : sh scripts/050_count_rsem.sh > log/050_count_rsem.log 2>&1 &

rsem-generate-data-matrix \
    `ls 04_RSEM/*.genes.results` \
    > 05_rsem_counts/GeneExpressionMatrix.tsv

```

以下の通りに実行
`sh scripts/050_count_rsem.sh > log/050_count_rsem.log 2>&1 &`


<br>

### edgeR

edgeRは以下のdocsがよくできている。
https://www.bioconductor.org/packages/release/bioc/vignettes/edgeR/inst/doc/edgeRUsersGuide.pdf

2回比較を行うので

```others/group.csv
Ctrl,G_mut
Ctrl,N_mut

```

上記のようなファイルを作成する。

<br>

以下のscriptは、`others`ディレクトリを操作するだけで比較対象を変えられるようにした。

```
#!/usr/bin/Rscript

# libralies : ライブラリ
library(edgeR)
library(dplyr)

# config : ファイル名等
matrix.path <- "05_rsem_counts/GeneExpressionMatrix.tsv"
sample.path <- "others/sample.csv"
group.deg <- read.table("others/group.csv", sep=",")

# 同じ処理を繰り返すための関数
ReadExpMatrix <- function(INPUT, SAMPLES) {

    df_exp <- read.delim(INPUT, row.names=1, header=F, skip=1)

    sample.metadata <- read.table(SAMPLES, sep=",")
    colnames(df_exp) <- sample.metadata[,2]

    treatment <- factor(as.vector(sample.metadata[,3]))
    return(DGEList(counts=df_exp, group=treatment))
}


RunEdgeRNorm <- function(y) {
    cpm <- cpm(y)
    keep <- rowSums(cpm > 1) >= 2
    y_expressed <- y[keep, ]
    y_norm <- calcNormFactors(y_expressed)  # Normalizing the data
    d_com <- estimateCommonDisp(y_norm)  # Estimating the Dispersion
    d_mod <- estimateTagwiseDisp(d_com)  # for routine differential expresion analysis
    return(d_mod)
}


# 業務には含まれないためskip
plot_basics <- function() {
    plotMDS(d, ,ethof="bcv", col=as.numeric(d$samples$group))
    legend("bottomleft", as.character(unique(d$samples$group)), col=1:3, pch=20)

    p_bcv <- plotBCV(d_mod)
    pdf(out.bcv)
    print(p_bcv)
    dev.off()
}


main <- function() {
    df <- ReadExpMatrix(matrix.path, sample.path)
    d <- RunEdgeRNorm(y=df)

    for (i in 1:dim(group.deg)[1]) {
        grp <- asplit(as.matrix(group.deg), 1)[[i]] %>% as.vector()
        sample1 <- grp[1]
        sample2 <- grp[2]

        BatchName <- paste0(sample1, "_vs_", sample2)
        par.dir <- file.path("06_diff", BatchName)
        dir.create(par.dir, recursive=T)
        table.path <- file.path(par.dir, paste0(BatchName, ".txt"))

        # 実際の処理
        et <- exactTest(d, pair=c(sample1, sample2))
        final <- topTags(et, n=nrow(et$table))

        write.table(final, file=table.path, sep="\t", append=F, quote=F)
    }
}

main()
```

<br>

以下の通りに実行
`Rscript scripts/060_edger.R`


