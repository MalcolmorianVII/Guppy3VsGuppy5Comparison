from Bio.Seq import Seq
import os
from Bio import SeqIO
import pandas as pd

indel_dir = '/Users/malcolmorian/Documents/Bioinformatics/Projects2021/Guppy3Guppy5/2021.08.17_NAPA/indel_Xtrization'
species = os.listdir(indel_dir)

print(species)

# acit3 = '/Users/malcolmorian/acinetoBacterTestCase/acineto_g3.fasta'
# acit5 = '/Users/malcolmorian/acinetoBacterTestCase/acineto_g5.fasta'
# #ref_seq = SeqIO.read(acit, "fasta").seq
#
# guppy3 = list(SeqIO.parse(acit3,"fasta"))
# # print(records3)
# r3 = SeqIO.to_dict(SeqIO.parse(acit3,"fasta"))
#
# # print(r3["contig_3"].seq)
# guppy5 = list(SeqIO.parse(acit5,"fasta"))

# print(records5)
#print(records[2].seq[16499:16601])

# Double indels
# print(guppy3[2].seq[341600:341700])
# print("------------G5--------------------")
# print(guppy5[1].seq[341600:341705])

# from collections import Counter

for sp in species:
    g5ex = pd.ExcelFile(
        f'{indel_dir}/{sp}',
        engine="openpyxl")
    g5un = pd.read_excel(g5ex,"g5_un")

    g5un['Homopolymer'] = ""
    for index, row in g5un.iterrows():
        row_set = set(row['REF'])
        #print(row['REF'])
        counts = {i: row['REF'].count(i) for i in row_set}
        vals = counts.values()
        for key in counts.keys():
            if counts[key] == max(vals):
                g5un['Homopolymer'][index] = key

    g5un.to_excel(
        f'{indel_dir}/{sp}',
        index=False)
