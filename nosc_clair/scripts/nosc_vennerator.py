import os, pandas as pd
from matplotlib_venn import venn2, venn2_circles, venn2_unweighted
from matplotlib_venn import venn3, venn3_circles
from matplotlib import pyplot as plt
base_nosc = '/Users/malcolmorian/Documents/Bioinformatics/Projects2021/Guppy3Guppy5/NOSC/nosc/Artificial'
pepper = f'{base_nosc}/pepper.xlsx'
gatk = f'{base_nosc}/gatk.xlsx'
# clair = f'{base_nosc}/clairmore5xCovacinetobacterOriginalIlluminaVCF.xlsx'
# more5Xcov = f'{base_nosc}/more5XcoverageAcinetobacter_mapped_original.txt'


def read_xlsx(file):
    df = pd.read_excel(file, engine='openpyxl')

    return df


# clair_df = read_xlsx(clair)
# print(clair_df)

gatk_df = read_xlsx(gatk)
# more5Xcov_df = pd.read_csv(more5Xcov,delimiter='\t')

pepper_df = read_xlsx(pepper)

# cla_set = set(clair_df['POS'])
# ga_set = set(gatk_df['POS'])
# pe_set = set(pepper_df['POS'])
#
# venn3(subsets = (cla_set,ga_set,pe_set),set_labels=('Clair','Gatk','Pepper'),alpha = 0.5)
#
# plt.show()

# gape = pd.merge(gatk_df,pepper_df,on='POS',how='inner')

# print(gape)

# print(clair_df)


# def intersect(*args):
#     intersected = pd.merge(*args, on='POS', how='inner')
#     return intersected
#
#
# def find_unique(*args):
#     unique = pd.concat([args[0], args[1]]).drop_duplicates(keep=False)
#     return unique


# Intersection df between clair_df,gatk_df & pepper_df

# clapega = len(intersect(clair_df, intersect(gatk_df, pepper_df)))
# claga = len(intersect(clair_df, gatk_df)) - clapega
# clape = len(intersect(clair_df,pepper_df)) - clapega
# gape = len(intersect(gatk_df,pepper_df)) - clapega


# print(f"clapega:  {clapega}")
# print(f"claga: {claga}")
# print(f"clape:  {clape}")
# print(f"gape: {gape}")
#
# # #Uniques for three dfs
# cla_unique = len(clair_df) - (clape + claga + clapega)
# pe_unique = len(pepper_df) - (clape + gape + clapega)
# ga_unique = len(gatk_df) - (claga + gape + clapega)

# print(f"cla_unique: {cla_unique}")
# print(f"pe_unique: {pe_unique}")
# print(f"ga_unique:  {ga_unique}")
# print(len(clair_df))

# 2021.11.23 filtering gatk_illumina based on less5Xcoverage
# print(gatk_df)

# Regenerating the VCFs without the masked regions
# gatk_more5Xcov_df = gatk_df.loc[(gatk_df["#CHROM"].isin(more5Xcov_df["#CHROM"])) & (gatk_df["POS"].isin(more5Xcov_df["POS"]))]
# clair_more5Xcov_df = clair_df.loc[(clair_df["#CHROM"].isin(more5Xcov_df["#CHROM"])) & (clair_df["POS"].isin(more5Xcov_df["POS"]))]
pepper_more5Xcov_df = pepper_df.loc[(pepper_df["#CHROM"].isin(more5Xcov_df["#CHROM"])) & (pepper_df["POS"].isin(more5Xcov_df["POS"]))]
# gatk_more5Xcov_df.to_excel(f'{base_nosc}/gatkmore5xCovacinetobacterOriginalIlluminaVCF.xlsx',index=False)
# clair_more5Xcov_df.to_excel(f'{base_nosc}/clairmore5xCovacinetobacterOriginalIlluminaVCF.xlsx',index=False)
pepper_more5Xcov_df.to_excel(f'{base_nosc}/peppermore5xCovacinetobacterOriginalIlluminaVCF.xlsx',index=False)

# print(more5Xcov_df)


