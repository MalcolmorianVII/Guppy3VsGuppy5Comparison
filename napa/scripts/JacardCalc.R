# Script for calculating the JI
# JI = | A ∩ B | / |A| + |B| - | A U B|
# In this case A = g3 unique
# B = g5 unique
# | A ∩ B| = g3g5 column

#library(readxl);library(dplyr);library(ggplot2)
JI <- function(g3,g5,g3g5) {
  union =  (g3 + g5 ) - g3g5
  J = g3g5/union
  return (J)
}


# Data path
vcfsIntersectIntersect <- read_excel("/Users/malcolmorian/Documents/Transfer/Docs/SNR-SARS-Cov/Guppy3Guppy5/2021.08.17_NAPA/2021.09.06.vcfIntersect.xlsx")
#View(vcfsIntersect)

# Calculating JI in vcfIntersect
JIAllSpecies <- JI(vcfsIntersect$g3uniq,vcfsIntersect$g5uniq,vcfsIntersect$g3g5intersect)
#JIAllSpecies

vcfsIntersect$JIndex <- JIAllSpecies  # Adding the JI


View(vcfsIntersect)

JI_mean <- mean(vcfsIntersect$JIndex)
JI_median <- median(vcfsIntersect$JIndex)

