library(readxl);library(dplyr);library(ggplot2)

all <- read_excel("/Users/malcolmorian/Documents/Transfer/Docs/SNR-SARS-Cov/Guppy3Guppy5/2021.08.17_NAPA/g3vsg5_napa_results.xlsx")
View(all);str(all)

all$GuppyVersion <- as.factor(all$GuppyVersion);all$Tool <- as.factor(all$Tool);all$Species <- as.factor(all$Species)


# plotter <- function(df,x,y,fill=None,labels=None) {
#   
#   ggplot(df,aes(x=x,y=y,fill=fill) + 
#            geom_dotplot(binaxis = "y",stackdir = "center",position = "dodge") + 
#            scale_y_continuous(sec.axis = dup_axis(name="Assembly accuracy", labels = c("99.7%","99.90%","99.94%","99.97%","99.998%")))) +
#            #   labs(x="Tools",
#            #        y = "Assembly qscore") +
#            #   ggtitle("Guppy v.3.6.1 vs Guppy v5.0.7 consensus accuracy") +
#            #   theme(legend.position = "none"))
# }


# Consensus Quality
# cons_acc <- all %>% group_by(GuppyVersion,Tool) %>% summarise(Species,Consensus_Quality,Q_score)
# 
# 
# cons_acc$GuppyVersionTool <- paste(cons_acc$GuppyVersion,cons_acc$Tool) 
# ggplot(cons_acc,aes(x=GuppyVersionTool,y = Q_score,fill=GuppyVersionTool)) +
#   geom_dotplot(binaxis = "y",stackdir = "center",position="dodge") +
#   scale_y_continuous(sec.axis = dup_axis(name="Assembly accuracy", labels = c("99.7%","99.90%","99.94%","99.97%","99.998%"))) +
#   labs(x="Tools",
#        y = "Assembly qscore") +
#   ggtitle("Guppy v.3.6.1 vs Guppy v5.0.7 consensus accuracy") +
#   theme(legend.position = "none")
# 


# For indels(normalized)
# Indels plot(normalized)
# ggplot(Indels,aes(x=GuppyVersionTool,y=Indels,fill=GuppyVersionTool)) +
#   geom_dotplot(binaxis = "y",stackdir = "center",position="dodge") + 
#   labs(y = "Indels",
#        x = "Tools") + 
#   scale_y_log10(limits = c(1, 20000)) +
#   ggtitle("Guppy v.3.6.1 vs v5.0.7 Indels") +
#   stat_summary(fun = median, fun.min = median, fun.max = median,
#                geom = "crossbar", width = 0.5) +
#   theme(legend.position = "none")

#Indels_df <-  all %>% select(-Substitution_Errors,-Consensus_Quality,-Q_score) %>% group_by(GuppyVersion,Tool)

# MEDAKA ONLY PLOTS

Indels_medaka_df <-  all %>% filter(Tool=="Medaka") %>% select(-Substitution_Errors,-Consensus_Quality,-Q_score) %>% group_by(GuppyVersion,Tool)
Indels_medaka_df$GuppyVersionTool <- paste(Indels_medaka_df$GuppyVersion,Indels_medaka_df$Tool)
#View(Indels_medaka_df)

ggplot(Indels_medaka_df,aes(x=GuppyVersionTool,y=Indels,fill=GuppyVersionTool)) +
    geom_dotplot(binaxis = "y",stackdir = "center",position="dodge") +
    labs(y = "Indels",
         x = "Tools") +
    scale_y_log10(limits = c(1, 20000)) +
    ggtitle("Guppy v.3.6.1 vs v5.0.7 Indels") +
    stat_summary(fun = median, fun.min = median, fun.max = median,
                 geom = "crossbar", width = 0.5) +
    theme(legend.position = "none")


# Indels variation statement
Indels_medaka_df
min = Indels_medaka_df %>% filter(Indels == min(Indels))
max = Indels_medaka_df %>% filter(Indels == max(Indels))
min;max
# subs
Subs_medaka_df <- all %>% filter(Tool=="Medaka") %>% select(-Indels,-Consensus_Quality,-Q_score) %>% group_by(GuppyVersion,Tool)
#Subs_df

Subs_medaka_df$GuppyVersionTool <- paste(Subs_medaka_df$GuppyVersion,Subs_medaka_df$Tool)
ggplot(Subs_medaka_df,aes(x=GuppyVersionTool,y=Substitution_Errors,fill=GuppyVersionTool)) +
  geom_dotplot(binaxis = "y",stackdir = "center",position="dodge") +
  labs(y = "Substitution errors",
       x = "Tools") +
  scale_y_log10(limits = c(1, 20000)) +
  ggtitle("Guppy v.3.6.1 vs v5.0.7 Substitution errors") +
  stat_summary(fun = median, fun.min = median, fun.max = median,
               geom = "crossbar", width = 0.5) +
  theme(legend.position = "none")


#KS TESTS

#Flye_Indels ks test
flye_indel3 <- Indels_df %>% filter(Tool == "Flye" & GuppyVersion == "guppy_3") %>% select(Indels)

#str(flye_indel3)
flye_indel5 <- Indels_df %>% filter(Tool == "Flye" & GuppyVersion == "guppy_5") %>% select(Indels)



flye_median_dif <- median(flye_indel3$Indels) - median(flye_indel5$Indels) # 2473 - 886
#flye_median_dif
ks.test(flye_indel3$Indels,flye_indel5$Indels)

#Medaka_Indels ks test
medaka_indel3 <- Indels_df %>% filter(Tool == "Medaka" & GuppyVersion == "guppy_3") %>% select(Indels)

#str(medaka_indel3)
medaka_indel5 <- Indels_df %>% filter(Tool == "Medaka" & GuppyVersion == "guppy_5") %>% select(Indels)

medaka_median_dif <- median(medaka_indel3$Indels) - median(medaka_indel5$Indels) # 313 - 174
#median_dif
ks.test(medaka_indel3$Indels,medaka_indel5$Indels)

#wilcokoxon test for indels
wilcox.test(flye_indel3$Indels,flye_indel5$Indels,paired=TRUE,alternative="two.sided")
wilcox.test(medaka_indel3$Indels,medaka_indel5$Indels,paired=TRUE,alternative="two.sided")

#cv function

cv <- function(x) sd(x)/mean(x)

# Coeficient of variation for indels
Indels_cv <- Indels_medaka_df %>% group_by(GuppyVersionTool) %>% summarise(Indels_cv = cv(Indels))

Indels_cv
# For subs(normalized)


#KS TESTS

#Flye_Subs ks test
flye_sub3 <- Subs_df %>% filter(Tool == "Flye" & GuppyVersion == "guppy_3") %>% select(Substitution_Errors)
#flye_sub3
#str(flye_sub3)
flye_sub5 <- Subs_df %>% filter(Tool == "Flye" & GuppyVersion == "guppy_5") %>% select(Substitution_Errors)
#flye_sub5
flye_median_dif <- median(flye_sub3$Substitution_Errors) - median(flye_sub5$Substitution_Errors) # 34.5
flye_median_dif
ks.test(flye_sub3$Substitution_Errors,flye_sub5$Substitution_Errors)

#Medaka_Subs ks test
medaka_sub3 <- Subs_df %>% filter(Tool == "Medaka" & GuppyVersion == "guppy_3") %>% select(Substitution_Errors)

#str(medaka_sub3)
medaka_sub5 <- Subs_df %>% filter(Tool == "Medaka" & GuppyVersion == "guppy_5") %>% select(Substitution_Errors)

#wilcokoxon test for subs
wilcox.test(flye_sub3$Substitution_Errors,flye_sub5$Substitution_Errors,paired=TRUE,alternative="two.sided")
wilcox.test(medaka_sub3$Substitution_Errors,medaka_sub5$Substitution_Errors,paired=TRUE,alternative="two.sided")

medaka_median_dif <- median(medaka_sub3$Substitution_Errors) - median(medaka_sub5$Substitution_Errors) #13.5
medaka_median_dif
ks.test(medaka_sub3$Substitution_Errors,medaka_sub5$Substitution_Errors)


#MEDIANS

#FLYE:
GUPPY3_INDELS_FLYE <- median(flye_indel3$Indels)
GUPPY5_INDELS_FLYE<- median(flye_indel5$Indels)

#MEDAKA
GUPPY3_INDELS_MEDAKA <-median(medaka_indel3$Indels)
GUPPY5_INDELS_MEDAKA <-median(medaka_indel5$Indels)
GUPPY3_INDELS_FLYE;GUPPY5_INDELS_FLYE;GUPPY3_INDELS_MEDAKA;GUPPY5_INDELS_MEDAKA
# SUBS
#FLYE
GUPPY3_SUBS_FLYE <- median(flye_sub3$Substitution_Errors)
GUPPY5_SUBS_FLYE <- median(flye_sub5$Substitution_Errors)

# MEDAKA
GUPPY3_SUBS_MEDAKA <- median(medaka_sub3$Substitution_Errors)
GUPPY5_SUBS_MEDAKA <- median(medaka_sub5$Substitution_Errors)

GUPPY3_SUBS_FLYE;GUPPY5_SUBS_FLYE;GUPPY3_SUBS_MEDAKA;GUPPY5_SUBS_MEDAKA

# Coeeficient of variation for subs
Subs_cv <- Subs_medaka_df %>% group_by(GuppyVersionTool) %>% summarise(Subs_cv = cv(Substitution_Errors))
Subs_cv


ggplot(Subs_df,aes(x=GuppyVersionTool,y=Substitution_Errors,fill=GuppyVersionTool)) +
  geom_dotplot(binaxis = "y",stackdir = "center",position="dodge") +
  labs(y = "Substitution Errors",
       x = "Tools") + 
  scale_y_log10(limits = c(1, 1000)) +
  scale_x_discrete() +
  stat_summary(fun = median, fun.min = median, fun.max = median,
                              geom = "crossbar", width = 0.5) +
  ggtitle("Guppy v.3.6.1 vs Guppy v5.0.7 Substitution Errors") + 
  theme(legend.position = "none")







