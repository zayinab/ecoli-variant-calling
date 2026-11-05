# E. coli Variant Calling Pipeline

A variant calling workflow that finds SNPs and indels in an evolved
*E. coli* sample compared with the ancestral reference strain REL606.

## Question
Which mutations does an evolved E. coli sample carry relative to REL606?

## Data
- Reference: E. coli REL606, GCA_000017985.1 (accession CP000819.1)
- Reads: SRR2584863 (Lenski long-term evolution experiment), downloaded as
  the first 500,000 read pairs

## Pipeline
FastQC -> fastp -> BWA-MEM -> samtools sort/index -> bcftools mpileup/call
(ploidy 1) -> bcftools filter (QUAL >= 30, DP >= 10)

## How to run
```bash
mamba create -n variants -c conda-forge -c bioconda bwa samtools bcftools fastp fastqc multiqc sra-tools -y
conda activate variants
bash scripts/01_download.sh
bash scripts/02_qc_trim.sh
bash scripts/03_call_variants.sh
```

## Results
- 827,534 reads aligned after trimming, with about 100% of reads mapped
- Mean coverage: XXx
- Raw variants: 29
- Filtered variants: **24** (**20 SNPs**, **4 indels**)
- Variant calls: `results/vcf/SRR2584863.filtered.vcf.gz`
- Summary statistics: `results/vcf/SRR2584863.stats.txt`

First 10 filtered variants:

| Position | Ref | Alt | QUAL |
|---|---|---|---|
| 9,972 | T | G | 225 |
| 263,235 | G | T | 184 |
| 281,923 | G | T | 225 |
| 377,000 | T | G | 200 |
| 433,359 | CTTTTTTT | CTTTTTTTT | 228 |
| 473,901 | CCGC | CCGCGC | 228 |
| 648,692 | C | T | 225 |
| 1,331,794 | C | A | 225 |
| 1,733,343 | G | A | 225 |
| 2,333,538 | AT | ATT | 228 |

## Limitations
- One sample, and reads were subsampled
- Variants are not annotated with gene effects (no SnpEff yet)
- Simple hard filters only (QUAL and DP)
- Indels in homopolymers and short repeats (for example at positions 433,359
  and 473,901) are error-prone for short-read callers and should be
  verified before being treated as real

## Author
Zainab, M.Sc. Bioinformatics, Jamia Millia Islamia
