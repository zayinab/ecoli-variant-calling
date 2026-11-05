#!/bin/bash
# Reference genome (E. coli REL606)
cd data/ref
wget -O ecoli_rel606.fna.gz \
  https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/000/017/985/GCA_000017985.1_ASM1798v1/GCA_000017985.1_ASM1798v1_genomic.fna.gz
gunzip -f ecoli_rel606.fna.gz
cd ../raw
# First 500,000 read pairs of the evolved sample (about 30x coverage)
fastq-dump -X 500000 --split-files --gzip SRR2584863
