#!/usr/bin/bash
# usage : scripts/010_fastqc.sh > log/010_fastqc.log 2>&1 &

############## config ##############

exp="fastp"
cores=8

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
