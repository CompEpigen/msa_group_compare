# library(biostrings)
library(ape)
library(seqinr)
library(tidyverse)
library(msa)
library(ggtree)

fasta1 <- "china_2019_covid_proteomes.fasta"
fasta2 <- "germany_2020_covid_proteomes.fasta"
msa_method <- "Muscle" # one of "ClustalW", "ClustalOmega", "Muscle"
seq_type <- "protein" # protein, dna, rna

target_protein <- "surface glycoprotein"

seq_set_1 <- readAAStringSet(fasta1, format="fasta")
seq_set_2 <- readAAStringSet(fasta2, format="fasta")

seq_set_1_ <- seq_set_1[ grepl(target_protein, names(seq_set_1)) ]
seq_set_2_ <- seq_set_2[ grepl(target_protein, names(seq_set_2)) ]

names(seq_set_1_) <- sapply(names(seq_set_1_), function(n) {
        return(strsplit(n, " ")[[1]][1])
})
names(seq_set_2_) <- sapply(names(seq_set_2_), function(n) {
        return(strsplit(n, " ")[[1]][1])
})

writeXStringSet(seq_set_1_, "china_2019_covid_surf_prot_seq.fasta", format="fasta")
writeXStringSet(seq_set_2_, "germany_2020_covid_surf_prot_seq.fasta", format="fasta")

############################################
## Step1: create MSA and calculate distance

fasta1 <- "china_2019_covid_surf_prot_seq.fasta"
fasta2 <- "germany_2020_covid_surf_prot_seq.fasta"
label1 <- "china_2019"
label2 <- "germany_2020"
msa_method <- "ClustalW" # one of "ClustalW", "ClustalOmega", "Muscle"
seq_type <- "protein" # protein, dna, rna
homology_method <- "identity" # "identity" or "similarity"

seq_set_1 <- readAAStringSet(fasta1, format="fasta")
seq_set_2 <- readAAStringSet(fasta2, format="fasta")

names(seq_set_1) <- paste(rep(label1, length(seq_set_1)), names(seq_set_1), sep=":")
names(seq_set_2) <- paste(rep(label2, length(seq_set_2)), names(seq_set_2), sep=":")

combined_seq_set <- c(seq_set_1, seq_set_2)

system.time(
    combined_msa <- msa(combined_seq_set, type=seq_type, method=msa_method)
)

combined_msa_aln <- msaConvert(combined_msa, type="seqinr::alignment")

dist_ <- dist.alignment(combined_msa_aln, homology_method)

dist_mat <- as.matrix(dist_)

## write out:
dist_ %>% saveRDS("dist.RDS")
dist_mat %>% write.table("dist.tsv")


##################################################
## Step 2: Build tree and vizualize

dist_path <- "dist.RDS"

dist_ <- readRDS(dist_path)

nj_tree <- nj(dist_)

seq_ids <- sapply(nj_tree$tip.label, function(n) {
        return(strsplit(n, ':')[[1]][2])
})
groups <- sapply(nj_tree$tip.label, function(n) {
        return(strsplit(n, ':')[[1]][1])
})
nj_tree$tip.label <- seq_ids
group_info <- split(seq_ids, groups)
nj_tree_grouped <- groupOTU(nj_tree, group_info)

nj_tree_plot <- ggtree(nj_tree_grouped, aes(color=group), size=1) +
    geom_tiplab(aes(color=group)) +
    geom_tippoint(aes(color=group), shape=16, size=2) +
    theme_tree2() +
    xlab("distance")

ggsave(
    "phylogenetic_tree.png",
    nj_tree_plot,
    width=10,
    height=10
)

