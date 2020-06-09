# library(biostrings)
library(ape)
library(seqinr)
library(tidyverse)
library(msa)
library(ggtree)

fasta1 <- "china_2019_covid_proteomes.fasta"
fasta2 <- "europe_2020_covid_proteomes.fasta"

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
writeXStringSet(seq_set_2_, "europe_2020_covid_surf_prot_seq.fasta", format="fasta")
