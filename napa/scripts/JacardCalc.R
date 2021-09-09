# Script for calculating the JI
# JI = | A ∩ B | / |A| + |B| - | A U B|
# In this case A = g3 unique
# B = g5 unique
# | A ∩ B| = g3g5 column

library(readxl);library(dplyr);library(ggplot2)
JI <- function(g3,g5,g3g5) {
  union =  (g3 + g5 ) - g3g5
  J = g3g5/union
  return (J)
}


# Data path
#vcfsIntersect <- read_excel("/Users/malcolmorian/Documents/Transfer/Docs/SNR-SARS-Cov/Guppy3Guppy5/2021.08.17_NAPA/2021.09.06.vcfIntersect.xlsx")
vcfsnormIntersect <- read_excel("/Users/malcolmorian/Documents/Transfer/Docs/SNR-SARS-Cov/Guppy3Guppy5/2021.08.17_NAPA/2021.09.09.vcfnormIntersect.xlsx")
View(vcfsnormIntersect)

# Calculating JI in vcfIntersect
JIAllSpecies <- JI(vcfsnormIntersect$g3uniq,vcfsnormIntersect$g5uniq,vcfsnormIntersect$g3g5intersect)
#JIAllSpecies

vcfsnormIntersect$JIndex <- JIAllSpecies  # Adding the JI


View(vcfsnormIntersect)

JI_mean <- mean(vcfsnormIntersect$JIndex)
JI_median <- median(vcfsnormIntersect$JIndex)
JI_median
