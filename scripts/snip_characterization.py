import indel_char as ind
import pandas as pd
import csv


base= '/Users/malcolmorian/Documents/Bioinformatics/Projects2021/Guppy3Guppy5/2021.08.17_NAPA/Indel_Xtrization/'
g3 = '/Users/malcolmorian/Documents/Bioinformatics/Projects2021/Guppy3Guppy5/2021.08.17_NAPA/Indel_Xtrization/g3'

g5 = '/Users/malcolmorian/Documents/Bioinformatics/Projects2021/Guppy3Guppy5/2021.08.17_NAPA/Indel_Xtrization/g5'


def write_subXzation(guppy, sp,output):
    with open(output, 'a') as f:
        writer = csv.writer(f)
        writer.writerow(['Contig', 'Leftmer', 'SNP(REF,ALT)', 'Pos', 'Rightmer', 'Guppy', 'Species'])

        gen = ind.read_in_genome(base + guppy + f'/{sp}/consensus.fasta')
        sp_df = pd.read_csv(base + guppy + f'/{sp}/{sp}_{guppy}norm.csv')
        sp_filter = sp_df.loc[sp_df['REF'].str.len() == sp_df['ALT'].str.len()]
        for index, row in sp_filter.iterrows():
            true_pos = row['POS'] - 1
            leftmer = gen[row['#CHROM']][true_pos - 10: true_pos]
            rightmer = gen[row['#CHROM']][row['POS']: row['POS'] + 10]
            contig = row['#CHROM']
            SNP = row['REF'] + "," + row['ALT']
            pos = row['POS']

            writer.writerow([contig, leftmer, SNP, pos, rightmer, guppy, sp])


def main():
    species = ['1_Acinetobacter_baumannii_J9', '2_Citrobacter_koseri_MINF_9D', '3_Enterobacter_kobei_MSB1_1B',
               '4_Haemophilus_unknown_M1C132_1', '5_Klebsiella_oxytoca_MSB1_2C', '6_CHF10J',
               '7_Klebsiella_variicola_INF345', '8_Serratia_marcescens_17-147-1671']

    for sp in species:
        write_subXzation('g3',sp,'/Users/malcolmorian/Documents/Bioinformatics/Projects2021/Guppy3Guppy5/2021.08.17_NAPA/SubXtrization/g3_subs.csv')
        write_subXzation('g5', sp,
                         '/Users/malcolmorian/Documents/Bioinformatics/Projects2021/Guppy3Guppy5/2021.08.17_NAPA/SubXtrization/g5_subs.csv')


if __name__ == '__main__':
    main()
# Testcase

#acit = g3 + '/1_Acinetobacter_baumannii_J9/1_Acinetobacter_baumannii_J9_g3norm.csv'

# ac_df = pd.read_csv(acit)

#print(ac_df)

# filt = ac_df.loc[ac_df['REF'].str.len() == ac_df['ALT'].str.len()]
#
# with open('subAcinetobacterXzed.csv','w') as f:
#     writer = csv.writer(f)
#     writer.writerow(['Contig','Leftmer','SNP(REF,ALT)','Pos','Rightmer','Guppy','Species'])
#
#     gen = ind.read_in_genome(g3+'/1_Acinetobacter_baumannii_J9/consensus.fasta')
#     for index,row in filt.iterrows():
#         true_pos = row['POS'] - 1
#         leftmer = gen[row['#CHROM']][true_pos-10 : true_pos]
#         rightmer = gen[row['#CHROM']][row['POS'] : row['POS'] + 10]
#         contig = row['#CHROM']
#         SNP = row['REF'] + "," + row['ALT']
#         pos = row['POS']
#
#         writer.writerow([contig,leftmer,SNP,pos,rightmer,'g3','Acineto'])


# print(filt)