library(tidyverse)

df <- read_csv('/Users/malcolmorian/Documents/Bioinformatics/Projects2021/Guppy3Guppy5/2021.08.17_NAPA/guppy5MashResults.csv')
df

#Improvement for substitution errors
ggplot(data = df) +
  geom_point(mapping = aes(x = Subimprovement,y = `Percentage Similarity`,color= Species)) +
  scale_y_log10(limits = c(1, 100)) +
  scale_x_log10(limits = c(1, 100)) +
  ggtitle('Improvement of substitution errors') +
  labs(x = '% improvement in genome',
       y = '% similarity to E.coli')


ggplot(data = df) +
  geom_point(mapping = aes(x = Subimprovement,y = `Percentage Similarity`,color= Species)) +
  xlim(0,100) +
  ylim(0, 100) +
  ggtitle('Improvement of substitution errors') +
  labs(x = '% improvement in genome',
       y = '% similarity to E.coli')


# Improvement for indels errors
ggplot(data = df) +
  geom_point(mapping = aes(x = Indelimprovement,y = `Percentage Similarity`,color= Species)) +
  xlim(0,100) +
  ylim(0,100) +
  ggtitle('Improvement of indels') +
  labs(x = '% improvement in genome',
       y = '% similarity to E.coli')

ggplot(data = df) +
  geom_point(mapping = aes(x = Indelimprovement,y = `Percentage Similarity`,color= Species)) +
  scale_y_log10(limits = c(1, 100)) +
  scale_x_log10(limits = c(1, 100)) +
  ggtitle('Improvement of indels') +
  labs(x = '% improvement in genome',
       y = '% similarity to E.coli')
