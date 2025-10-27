#!/bin/bash

# --- CONFIGURATION ---
# IMPORTANT: Adjust 'suazz' to your actual CyVerse username for project path
PROJECT_ROOT="/home/jovyan/data-store/home/suazz/DGE/Melanoma_DGE_VC"
SRRS=("SRR7895123" "SRR7895131" "SRR7895141" "SRR7895149")
REF_DIR="$PROJECT_ROOT/Reference"
INDEX_PATH="$REF_DIR/hg38_kallisto_index.idx"
INPUT_DIR="$PROJECT_ROOT/Raw_Data/Trimmed_Data"
OUTPUT_DIR="$PROJECT_ROOT/Kallisto_Quant"
mkdir -p "$PROJECT_ROOT"/Raw_Data "$REF_DIR" "$INPUT_DIR" "$OUTPUT_DIR"

# Navigate to the correct directory
cd "$PROJECT_ROOT"

# --- 1. TOOL INSTALLATION (Assumes Conda is active) ---
# NOTE: This block was executed in pieces throughout the project
conda install -c bioconda sra-tools fastp kallisto -y
echo "Core tools installed/verified."

# --- 2. RAW DATA DOWNLOAD & CLEANUP (fastq-dump, fastp) ---
cd Raw_Data
for ID in "${SRRS[@]}"; do
    echo "Downloading and splitting raw data for $ID..."
    # Downloads, splits (creates _1.fastq), and gzips files
    fastq-dump --split-files --gzip $ID 
    
    # Trim reads (assuming Single-End _1 file contains the data)
    fastp -i "${ID}_1.fastq.gz" -o "$INPUT_DIR/${ID}_clean.fastq.gz" \
          -q 20 -u 50 -n 10
    
    # Clean up large unzipped raw files if they exist (optional)
    rm -f "${ID}_1.fastq" "${ID}_2.fastq"
done
cd "$PROJECT_ROOT" # Return to project root

# --- 3. REFERENCE DOWNLOAD & KALLISTO INDEX ---
cd "$REF_DIR"
# Download Transcriptome FASTA (hg38) locally
wget -O human_transcripts.fa.gz https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_45/gencode.v45.transcripts.fa.gz
gunzip human_transcripts.fa.gz

# Build KALLISTO INDEX
kallisto index -i "$INDEX_PATH" -k 25 human_transcripts.fa 
cd "$PROJECT_ROOT"

# --- 4. KALLISTO QUANTIFICATION ---
for ID in "${SRRS[@]}"; do
    echo "Quantifying $ID with Kallisto..."
    # --single flag is crucial as we only have the single _clean.fastq.gz file
    kallisto quant -i "$INDEX_PATH" \
                   -o "$OUTPUT_DIR/$ID" \
                   --single -l 200 -s 20 \
                   "$INPUT_DIR/${ID}_clean.fastq.gz"
done

echo "BASH Pipeline Complete. Quantification files ready in $OUTPUT_DIR"
