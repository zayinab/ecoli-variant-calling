#!/bin/bash
set -e
REF=data/ref/ecoli_rel606.fna
S=SRR2584863

# Index reference
bwa index $REF
samtools faidx $REF

# Align, sort and index
bwa mem -t 4 $REF data/trimmed/${S}_1.fq.gz data/trimmed/${S}_2.fq.gz \
  | samtools sort -@ 4 -o results/bam/${S}.sorted.bam
samtools index results/bam/${S}.sorted.bam
samtools flagstat results/bam/${S}.sorted.bam > results/bam/${S}.flagstat.txt

# Call variants (bacteria are haploid, so ploidy is 1)
bcftools mpileup -Ou -f $REF results/bam/${S}.sorted.bam \
  | bcftools call -mv --ploidy 1 -Oz -o results/vcf/${S}.raw.vcf.gz
bcftools index results/vcf/${S}.raw.vcf.gz

# Filter: quality >= 30 and depth >= 10
bcftools filter -i 'QUAL>=30 && DP>=10' -Oz \
  -o results/vcf/${S}.filtered.vcf.gz results/vcf/${S}.raw.vcf.gz
bcftools index results/vcf/${S}.filtered.vcf.gz

# Summary numbers
bcftools stats results/vcf/${S}.filtered.vcf.gz > results/vcf/${S}.stats.txt
echo "Raw variants:      $(bcftools view -H results/vcf/${S}.raw.vcf.gz | wc -l)"
echo "Filtered variants: $(bcftools view -H results/vcf/${S}.filtered.vcf.gz | wc -l)"
echo "SNPs:              $(bcftools view -H -v snps results/vcf/${S}.filtered.vcf.gz | wc -l)"
echo "Indels:            $(bcftools view -H -v indels results/vcf/${S}.filtered.vcf.gz | wc -l)"
