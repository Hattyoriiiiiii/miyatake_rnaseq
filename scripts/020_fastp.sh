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
