#!/usr/bin/bash
# usage : sh scripts/050_count_rsem.sh > log/050_count_rsem.log 2>&1 &

rsem-generate-data-matrix \
    `ls 04_RSEM/*.genes.results` \
    > 05_rsem_counts/GeneExpressionMatrix.tsv
