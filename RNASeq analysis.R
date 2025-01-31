setwd('Desktop/Others/RNAseq/')
if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("DESeq2")
library(DESeq2)
library(tidyverse)

#https://github.com/kpatel427/YouTubeTutorials/blob/main/runDESeq2.R