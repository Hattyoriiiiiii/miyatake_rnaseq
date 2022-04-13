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
    03_align/${sample}.Aligned.toTranscriptome.out.bam \
    ~/indexes/RSEM_reference/RSEM_reference \
    04_RSEM/${sample} 
done < others/sample.txt
