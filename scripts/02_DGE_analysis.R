# --- DGE STATISTICAL ANALYSIS SCRIPT (Phase 3) ---

# 1. Setup and Library Loading
library(tximport)
library(DESeq2)

# Set Working Directory (Crucial for accessing files created by the bash script)
setwd("/home/jovyan/data-store/home/suazz/DGE/Melanoma_DGE_VC/") 

# 2. Load Metadata and Quantification Paths
# NOTE: Assumes 'samples.txt' is correctly created and uploaded to 'data/samples.txt'
samples <- read.table("data/samples.txt", header = TRUE) 
KALLISTO_PATH <- file.path(getwd(), "Kallisto_Quant")

# Define file paths to the Kallisto output
files <- file.path(KALLISTO_PATH, samples$RunID, "abundance.tsv") 
names(files) <- samples$SampleName

# 3. Run tximport
txi <- tximport(files, type="kallisto", txOut=TRUE)

# 4. Set up and Run DESeq2 Model
colData <- data.frame(row.names=samples$SampleName, samples)
colData$Treatment_Status <- factor(colData$Treatment_Status, levels=c("Pre", "Post"))

dds <- DESeqDataSetFromTximport(txi, colData = colData, design = ~ Treatment_Status)
dds <- DESeq(dds)

# 5. Get Results and Save Final CSV
res <- results(dds, contrast=c("Treatment_Status", "Post", "Pre"))
res_ordered <- res[order(res$padj),]

# SAVE FINAL DELIVERABLE
write.csv(as.data.frame(res_ordered), file="data/DGE_Final_Results.csv")

print("DGE Statistical Analysis COMPLETE. Final results saved to data/DGE_Final_Results.csv")
