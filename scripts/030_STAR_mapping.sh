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

