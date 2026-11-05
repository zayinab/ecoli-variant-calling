# E. coli Variant Calling Pipeline

Variant calling workflow that finds SNPs and indels in an evolved
*E. coli* sample compared with the ancestral reference strain REL606.

## Question
Which mutations does an evolved E. coli sample carry relative to REL606?

## Data
- Reference: E. coli REL606, GCA_000017985.1
- Reads: SRR2584863 (Lenski long-term evolution experiment), subsampled to
  500,000 read pairs

## Pipeline
FastQC → fastp → BWA-MEM → samtools sort/index → bcftools mpileup/call →
bcftools filter (QUAL >= 30, DP >= 10)

## How to run
```bash
mamba create -n variants -c conda-forge -c bioconda bwa samtools bcftools fastp fastqc multiqc sra-tools -y
conda activate variants
bash scripts/01_download.sh
bash scripts/02_qc_trim.sh
bash scripts/03_call_variants.sh
```

## Results
- Mapping rate: [X]%
- Raw variants: [N], filtered variants: [N] ([N] SNPs, [N] indels)
- Output: `results/vcf/SRR2584863.filtered.vcf.gz`

## Limitations
- One sample, subsampled reads
- Variants are not annotated with gene effects (no SnpEff yet)
- Simple hard filters (QUAL and DP) only

## Author
Zainab, M.Sc. Bioinformatics, Jamia Millia Islamia# ecoli-variant-calling
Variant calling pipeline for E. coli: BWA, samtools, bcftools
