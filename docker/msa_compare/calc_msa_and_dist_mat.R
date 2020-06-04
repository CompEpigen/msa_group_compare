# library(biostrings)
library(ape)
library(seqinr)
library(tidyverse)
library(msa)
library(ggtree)

args <- commandArgs(trailingOnly = TRUE)

fasta1 <- args[1]
fasta2 <- args[2]
label1 <- args[3]
label2 <- args[4]
msa_method <- args[5] # one of "ClustalW", "ClustalOmega", "Muscle"
seq_type <- args[6] # protein, dna, rna
homology_method <- args[7] # "identity" or "similarity"

seq_set_1 <- readAAStringSet(fasta1, format="fasta")
seq_set_2 <- readAAStringSet(fasta2, format="fasta")

names(seq_set_1) <- paste(rep(label1, length(seq_set_1)), names(seq_set_1), sep=":")
names(seq_set_2) <- paste(rep(label2, length(seq_set_2)), names(seq_set_2), sep=":")

combined_seq_set <- c(seq_set_1, seq_set_2)

combined_msa <- msa(combined_seq_set, type=seq_type, method="ClustalW")

combined_msa_aln <- msaConvert(combined_msa, type="seqinr::alignment")

dist_ <- dist.alignment(combined_msa_aln, homology_method)

dist_mat <- as.matrix(dist_)

## write out:
dist_ %>% saveRDS("dist.RDS")
dist_mat %>% write.table("distance_matrix.tsv")
