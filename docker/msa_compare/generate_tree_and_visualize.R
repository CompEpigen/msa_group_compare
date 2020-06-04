# library(biostrings)
library(ape)
library(seqinr)
library(tidyverse)
library(msa)
library(ggtree)

args <- commandArgs(trailingOnly = TRUE)

dist_path <- args[1]

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

nj_tree_plot <- ggtree(nj_tree_grouped, aes(color=group)) +
    geom_tiplab(aes(color=group)) +
    theme_tree2() +
    xlab("distance")
    
ggsave(
    "phylogenetic_tree.png",
    nj_tree_plot,
    width=10,
    height=10
)

