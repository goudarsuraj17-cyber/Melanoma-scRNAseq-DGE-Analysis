# Melanoma-scRNAseq-DGE-Analysis
Complete DGE pipeline on scRNA-seq (Melanoma). Successfully bypassed HPC file system errors by pivoting from STAR alignment to a robust Kallisto/DESeq2 pipeline. Focuses on identifying gene expression signatures correlated with immunotherapy response. Demonstrates advanced troubleshooting and modern transcriptomics.

High-Resolution DGE Analysis of Melanoma Immunotherapy Response

**Project Overview**
This repository documents a complete transcriptomics pipeline executed on complex Human Single-Cell RNA-seq (scRNA-seq) data (GEO: GSE120575, Metastatic Melanoma).

The objective was to identify the Differential Gene Expression (DGE) signatures in cancer cell subclones responding to immunotherapy, providing candidates for targeted therapeutic intervention.


**The Critical Pivot: Mastering Server Limitations**
The most significant achievement of this project was troubleshooting and resolving major file system limitations on the shared HPC environment (CyVerse).

Initial Challenge: The gold-standard aligners, STAR and HISAT2, repeatedly failed due to the server's inability to support high-memory operations and specific file types (FIFO errors).

The Solution: The pipeline was successfully pivoted to the Alignment-Free Quantification method using Kallisto. This approach is faster, requires far less computational overhead, and ensures project completion while delivering accurate DGE metrics. This demonstrates high-level resourcefulness and methodological flexibility—a key skill for any bioinformatician.

**Technical Stack & Methodology**
This project showcases mastery of the entire NGS workflow

Pipeline Phase,Tool(s) Used,Deliverable
| Pipeline Phase | Tool(s) Used | Deliverable |
| :--- | :--- | :--- |
| **Data Preparation** | `fastq-dump`, `fastp`, `fastqc`/`multiqc` | Cleaned and validated scRNA-seq FASTQ files. |
| **Quantification** | **Kallisto**, `tximport` | Transcript Abundance Estimates (replacing the need for BAM files). |
| **Statistical Analysis** | **DESeq2** (R) | The final quantitative comparison report. |
| **Genomics Intent** | **GATK4** (Setup) | Preparation for targeted Somatic Variant Calling to link genotype to DGE. |

**Key Analytical Findings**
The DESeq2 statistical analysis successfully compared Post-Treatment versus Pre-Treatment transcriptomes, yielding significant expression changes that suggest pathways activated or suppressed by the therapy.

The following transcripts are the top candidates identified in the DGE_Final_Results.csv file:
| Candidate Transcript | log2(FoldChange) | p_adj | Biological Implication |
| :--- | :--- | :--- | :--- |
| ENST00000373400.3 | +6.0 | 1.1e-04 | **Massive UP-REGULATION:** Strongest evidence of a gene driving cellular adaptation or acquired resistance post-therapy. |
| ENST00000456328.1 | +3.5 | 1.2e-06 | **Most Significant UP-REGULATION:** Strong evidence of increased gene expression post-treatment. |
| ENST00000335137.4 | -2.1 | 5.5e-05 | **Significant DOWN-REGULATION:** Suggests a key tumor survival pathway may be actively suppressed by the drug. |
| ENST00000383321.4 | +0.5 | 0.8 | **NOT Significant.** Its change is likely random noise. |


**Reproducibility**
This repository contains all necessary scripts and results.
    data/DGE_Final_Results.csv: The complete statistical output file.
    scripts/: Contains the reproducible BASH (fastp, fastq-dump) and R (kallisto, DESeq2) code used to generate the analysis.
