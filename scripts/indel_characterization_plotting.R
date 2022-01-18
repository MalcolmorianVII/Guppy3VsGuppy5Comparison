library(tidyverse)


species_df <- read_csv('/Users/malcolmorian/Documents/Bioinformatics/Projects2021/Guppy3Guppy5/2021.08.17_NAPA/Indel_Xtrization/indel_checked/AllspeciesIndelChecked.csv')

species_df

g3_df <- species_df %>% select(Nuc,`Homopolymer Length`,g3count,g3prop,Species) %>% rename(count = g3count, prop=g3prop)
g3_df $ Guppy <- as.factor("g3")
g3_df
g5_df <- species_df %>% select(Nuc,`Homopolymer Length`,g5count,g5prop,Species) %>% rename(count = g5count, prop=g5prop)
g5_df $ Guppy <- as.factor("g5")
g5_df

unique_df <- bind_rows(g3_df,g5_df)
#unique_df <- full_join(g3_df, g5_df, by = c("Species", "Nuc", "Homopolymer Length"))
unique_df
unique_df$`Homopolymer Length` <- as.factor(unique_df$`Homopolymer Length`)

# Make list of variable names to loop over.
# spp <- c('Klebsiella oxytoca')
species <- c('Acinetobacter baumannii','Citrobacter koseri','Enterobacter kobei','Haemophilus unknown', 'Klebsiella oxytoca', 'Salmonella isangi', 'Klebsiella variicola', 'Serratia marcescens')

nuc <- c('A', 'T', 'C', 'G')
nuc_plots <- list()

for (s in species){
    for (n in nuc){
      d <- unique_df %>% filter(Species == s, Nuc == n)
      g <- ggplot(data = d) + geom_bar(aes(x = `Homopolymer Length`,y = prop,fill=Guppy),stat = "identity",position = "dodge") +
        ggtitle(paste(s, ' ', n))
      ggsave(g, file=paste0("/Users/malcolmorian/Documents/Bioinformatics/Projects2021/Guppy3Guppy5/2021.08.17_NAPA/Indel_Xtrization/indel_checked/2021.10.19.prop_plots/",s,"_ ","plot_", n,".png"), width = 14, height = 10, units = "cm")
      }
  }

#Show all species plots -> group_by Nuc




