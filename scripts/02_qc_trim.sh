#!/bin/bash
fastqc data/raw/*.fastq.gz -o results/qc -t 4
fastp -i data/raw/SRR2584863_1.fastq.gz -I data/raw/SRR2584863_2.fastq.gz \
      -o data/trimmed/SRR2584863_1.fq.gz -O data/trimmed/SRR2584863_2.fq.gz \
      -h results/qc/fastp.html -j results/qc/fastp.json -w 4
