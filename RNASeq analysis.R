setwd("/Users/mckenzir/Desktop/Others/RNAseq")
if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("DESeq2")
library(DESeq2)
library(tidyverse)

#https://github.com/kpatel427/YouTubeTutorials/blob/main/runDESeq2.R

read.csv('counts_matrix.csv') -> counts_matrix
#Comes with X in front of the names so chose to load the R data files prepared by Andrew instead
read.csv('filtered_counts_matrix.csv') -> filtered_counts_matrix
read.csv('sample_info.csv') -> sample_info

load("~/Desktop/Others/RNAseq/counts_matrix.RData")
load("~/Desktop/Others/RNAseq/filtered_counts_matrix.RData")

all(colnames(counts_matrix) %in% rownames(sample_info))
all(colnames(counts_matrix) == rownames(sample_info))

#The row names were 1-24 so they needed to be changed to the actual names of the samples

rownames(sample_info) <- c('1b_1h_IL12','1h_1h_IL12','1b_1h_IL18','1h_6h_null','1b_6h_IL18','1e_6h_IL18',
                           '1e_1h_IL18','1h_6h_IL18','1b_6h_IL12','1e_6h_null','1h_1h_IL18','1b_6h_null',
                           '1e_1h_IL12','1h_6h_IL12','1e_1h_null','1b_1h_null','1h_1h_aCD3','1e_6h_aCD3',
                           '1h_6h_aCD3','1h_1h_null','1e_1h_aCD3','1b_1h_aCD3','1e_6h_IL12','1b_6h_aCD3')

dds <- DESeqDataSetFromMatrix(countData = counts_matrix,
                              colData = sample_info,
                              design = ~ Time_treatment)

dds2 <- DESeqDataSetFromMatrix(countData = counts_matrix,
                              colData = sample_info,
                              design = ~ Time + Treatment)
ddsDE <- DESeq(dds)
ddsDE2 <- DESeq(dds2)

resultsNames(ddsDE)
resultsNames(ddsDE2)

keepdds_200 <- rowSums(counts(dds)) >= 200
keepdds2_200 <- rowSums(counts(dds2)) >= 200

ddskeep <- dds[keepdds_200,]
dds2keep <- dds2[keepdds2_200,]

dds$Time_treatment <- factor(dds$Time_treatment, levels = c("PBS"))
dds2$Time_Treatment <- factor(dds$Time_treatment, levels = c("PBS"))

ddsDET_T <- DESeq(dds2)
resT_T <- results(ddsDET_T)

summary(resT_T)

resT_T0.05 <- results(ddsDET_T, alpha = 0.05)
summary(resT_T0.05)

dds2keep$Time_Treatment <- factor(dds$Time_treatment, levels = c("PBS"))
dds2keepDET_T <- DESeq(dds2keep)
res2keepT_T0.05 <- results(dds2keepDET_T, alpha = 0.05)
summary(res2keepT_T0.05)

resultsNames(dds2keepDET_T)

plotMA(res2keepT_T0.05)
