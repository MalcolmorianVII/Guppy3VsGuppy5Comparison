import pandas as pd


def merge(g3csv, g5csv, output):
    g3df = pd.read_csv(g3csv)
    g5df = pd.read_csv(g5csv)

    outer_merged = pd.merge(g3df, g5df, how="outer", on=["Nuc", "Homopolymer Length"]).fillna(0)
    # outer_merged = outer_merged.fillna(0)

    # Filtering homopolymer lengths of <= 1

    outer_merged = outer_merged[outer_merged['Homopolymer Length'] > 1]
    outer_merged['g3count'], outer_merged['g5count'] = outer_merged['g3count'].astype(int), outer_merged[
        'g5count'].astype(int)

    outer_merged.to_csv(output, index=False)


def add_prop(gcsv, output):
    gdf = pd.read_csv(gcsv)
    gdf['g3prop'] = ''
    gdf['g5prop'] = ''
    g3_props = {n: gdf[gdf['Nuc'] == n]['g3count'].sum() for n in ('A', 'C', 'T', 'G')}
    g5_props = {n: gdf[gdf['Nuc'] == n]['g5count'].sum() for n in ('A', 'C', 'T', 'G')}
    for index, row in gdf.iterrows():
        gdf['g3prop'][index], gdf['g5prop'][index] = (row['g3count'] / g3_props[row['Nuc']]) * 100, (
                    row['g5count'] / g5_props[row['Nuc']]) * 100

    gdf['g3prop'], gdf['g5prop'] = gdf['g3prop'].astype(int), gdf[
        'g5prop'].astype(int)
    gdf = gdf.reindex(columns=['Nuc', 'Homopolymer Length', 'g3count', 'g3prop', 'g5count', 'g5prop'])
    gdf.to_csv(output, index=False)


def add_species_column(gcsv,species,output):
    gdf = pd.read_csv(gcsv)

    gdf['Species'] = ''

    for index,row in gdf.iterrows():
        gdf['Species'][index] = species

    gdf.to_csv(output,index = False)


def merge_data(in_data, out_df):
    in_df = pd.read_csv(in_data)
    out_df = out_df.append(in_df).fillna(0)
    return out_df


def main():
    species = ['1_Acinetobacter_baumannii_J9', '2_Citrobacter_koseri_MINF_9D', '3_Enterobacter_kobei_MSB1_1B',
               '4_Haemophilus_unknown_M1C132_1', '5_Klebsiella_oxytoca_MSB1_2C', '6_CHF10J',
               '7_Klebsiella_variicola_INF345', '8_Serratia_marcescens_17-147-1671']

    species_guppy3_data = '/Users/malcolmorian/Documents/Bioinformatics/Projects2021/Guppy3Guppy5/2021.08.17_NAPA/Indel_Xtrization/g3'
    species_guppy5_data = '/Users/malcolmorian/Documents/Bioinformatics/Projects2021/Guppy3Guppy5/2021.08.17_NAPA/Indel_Xtrization/g5'
    base_dir = '/Users/malcolmorian/Documents/Bioinformatics/Projects2021/Guppy3Guppy5/2021.08.17_NAPA/Indel_Xtrization/indel_checked'
    out_df = pd.DataFrame(columns=['Nuc', 'Homopolymer Length', 'g3count', 'g3prop', 'g5count', 'g5prop','Species'])
    for sp in species:
        homolength = f'{base_dir}/{sp}indelChecked.csv'
        out3 = f'{species_guppy3_data}/{sp}/{sp}_g3indelChecked.csv'
        out5 = f'{species_guppy5_data}/{sp}/{sp}_g5indelChecked.csv'
        sp = ' '.join(sp.split('_')[1:3])
        if sp == 'CHF10J':
            sp = 'Salmonella isangi'
        # print(sp)
        merge(out3, out5, homolength)
        add_prop(homolength,homolength)
        add_species_column(homolength,sp,homolength)
        out_df = merge_data(homolength, out_df)

    # print(out_df)
    out_df.to_csv(
        '/Users/malcolmorian/Documents/Bioinformatics/Projects2021/Guppy3Guppy5/2021.08.17_NAPA/Indel_Xtrization/indel_checked/AllspeciesIndelChecked.csv',
        index=False)


if __name__ == '__main__':
    main()
