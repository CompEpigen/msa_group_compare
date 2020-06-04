FROM conda/miniconda3

LABEL author="Kersten Breuer, Cancer Epigenomics, Plass Team, DKFZ 2019" \
    maintainer="kersten-breuer@outlook.com"

# install needed unix packages
ENV DEBIAN_FRONTEND noninteractive
# RUN apt-get update --fix-missing -qq; \
#     apt-get install -y \
# 	libboost-all-dev \
# 	wget \
# 	tar \
# 	cmake \
# 	zlib1g-dev  \
# 	bzip2 \
# 	libghc-bzlib-dev \
# 	zlib1g-dev \
# 	liblzma-dev  \
# 	libncurses5-dev \
# 	imagemagick \
# 	gawk \
# 	gnupg2 \
# 	curl \
# 	libcurl4-openssl-dev

RUN conda install -c conda-forge -c bioconda \
	bioconductor-msa \
    r-tidyverse \
    r-ape \
    bioconductor-ggtree  \
    bioconductor-biostrings \
    r-seqinr
