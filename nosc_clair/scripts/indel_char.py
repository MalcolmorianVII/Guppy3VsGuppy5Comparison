import csv

from Bio import SeqIO

from collections import Counter


def read_in_vars(var_handle):
    vars = []

    with open(var_handle) as fi:
        lines = fi.readlines()

        for line in lines[1:]:
            # print()

            vars.append(line.strip().split(','))

    return vars


def read_in_genome(genome_handle):
    output_genome = {}

    genome = SeqIO.parse(genome_handle, 'fasta')

    for x in genome:
        # print(x)

        assert x.id not in output_genome

        output_genome[x.id] = x.seq

    return output_genome


def char_vars(vars, genome, guppy):
    """

    1. what nucleotide follows the variant position?

    2. is there a homopolymer of that nucleotide?

        a. if so, how long is it?

    """
    insertion_error_in_homopolymer = 0
    deletion_error_in_homopolymer = 0
    nt_count_dict = {'A': [], 'T': [], 'C': [], 'G': []}
    for var in vars:
        #print(var)
        if len(var[2]) != len(var[3]):
            pos = int(var[1])
            ref_nt = genome[var[0]][pos - 1]
            following_nt = genome[var[0]][pos]

            # non-matching insertions into homopolymers e.g. AAA -> ATAA
            alt_string = ''.join(genome[var[0]][pos - 1: pos + 100])
            alt_string = alt_string.replace(var[2], var[3], 1)
            if alt_string.startswith(('AA', 'TT', 'CC', 'GG')):
                k = -(len(var[2]) - len(var[3]))
                # k = 0
                for nt in alt_string:
                    if nt == ref_nt:
                        # print(genome[var[0]][pos:pos + 2])
                        k += 1
                    else:
                        # print(i)
                        if k > 1:
                            insertion_error_in_homopolymer += 1
                        # if i == 1:
                        # print()
                        # print(var)
                        # print('remember that the count on the line below referes to the alt, not the ref which is the sequence below')
                        # print(f'The following nt is {ref_nt} & its count is {k}')
                        # print(f"Finding homopolymer of length 1 on position {(pos - 1)} in the genome" )
                        # print(genome[var[0]][pos-1:pos+10])
                        # print(guppy)
                        break


            # this checks for if the variant position is the same as the following base.
            # if it is, then this error is likely to be an insertion of a different base within the homopolymer
            # deletions within homopolymers e.g. ATAA -> AAA
            elif genome[var[0]][pos - 1] == genome[var[0]][pos]:
                # check that the last base of hte alt isn't the same as the ref
                # not sure about this logic...
                if var[3][-1] != var[2][0]:
                    # see explanation of j below where we set i
                    j = -(len(var[2]) - len(var[3]))
                    # j = 0
                    for nt in genome[var[0]][pos - 1:pos + 1000]:
                        if nt == following_nt:
                            # print(genome[var[0]][pos:pos + 2])
                            j += 1
                        else:
                            # print(i)
                            if j > 1:
                                deletion_error_in_homopolymer += 1
                                # print()
                                # print(var)
                                # print(f'The following nt is {following_nt} & its count is {j}')
                                # print('remember that the count on the line below referes to the alt, not the ref which is the sequence below')
                                # print(f"Finding homopolymer of length 1 on position {(pos - 1)} in the genome" )
                                # print(genome[var[0]][pos-1:pos+10])
                                # print(guppy)
                            break


            else:
                # print()
                # print(var)
                # print(genome[var[0]][pos - 1: pos + 10])
                # print(guppy)
                # print(genome[var[0]][pos - 1])

                # since we are using the nanopore genome as the reference, the alt actually contains information about
                # the true length of the variants. therefore, we need to change the length of thehomopolymers we're
                # reporting in order to reflect the alt, rathr than the ref.
                # we do this by taking away the lenght of the alt from the length of the ref and then flipping the sign
                # of the answer.
                i = -(len(var[2]) - len(var[3]))

                for nt in genome[var[0]][pos:pos + 1000]:
                    if nt == following_nt:
                        # print(genome[var[0]][pos:pos + 2])
                        i += 1
                    else:
                        # print(i)
                        nt_count_dict[following_nt].append(i)
                        # if i == 1:
                        # print()
                        # print(var)
                        # print('remember that the count on the line below referes to the alt, not the ref which is the sequence below')
                        # print(f'The following nt is {following_nt} & its count is {i}')
                        # print(f"Finding homopolymer of length 1 on position {(pos - 1)} in the genome" )
                        # print(genome[var[0]][pos-1:pos+10])
                        break

    # pprint.pprint(nt_count_dict)

    output_dict = {}
    for nt in nt_count_dict:
        output_dict.update({nt: Counter(nt_count_dict[nt])})
        # print(nt, Counter(nt_count_dict[nt]))

    return output_dict


def write_results(char_vars_output, guppy, output):
    """

    :param guppy:
    :param char_vars_output: Output of char_vars() i.e a dict where nt are keys & counter obj are values for each nt
    :param output: name of csv file to be produced
    :return:
    """

    with open(output, 'w') as out:
        writer = csv.writer(out)
        writer.writerow(['Nuc', 'Homopolymer Length', f'{guppy}count'])
        for nt in char_vars_output.keys():
            # char_vars_output will be dict obj with key == nt & value == Counter obj
            # print(char_vars_output[nt])

            for length in char_vars_output[nt]:  # Homopolymer length in Counter obj
                writer.writerow([nt, length, char_vars_output[nt][length]])


def run_for_each_guppy(gcsv, gfasta, guppy_version, output):
    vars = read_in_vars(gcsv)
    genome = read_in_genome(gfasta)
    char_vars_results = char_vars(vars, genome, guppy_version)
    print("Writing to csv file")
    write_results(char_vars_results, guppy_version, output)


def main():
    # # var_handle = '/Users/malcolmorian/acinetoBacterTestCase/acinetobacter_g5normed.csv'
    # #
    # # genome_handle = '/Users/malcolmorian/acinetoBacterTestCase/acineto_g5.fasta'
    # species = ['1_Acinetobacter_baumannii_J9','2_Citrobacter_koseri_MINF_9D','3_Enterobacter_kobei_MSB1_1B',
    #            '4_Haemophilus_unknown_M1C132_1','5_Klebsiella_oxytoca_MSB1_2C','6_CHF10J',
    #            '7_Klebsiella_variicola_INF345','8_Serratia_marcescens_17-147-1671']
    #
    # species_ref3_dir = '/Users/malcolmorian/Documents/Bioinformatics/Projects2021/Guppy3Guppy5/2021.08.17_NAPA/Indel_Xtrization/g3'
    # species_ref5_dir = '/Users/malcolmorian/Documents/Bioinformatics/Projects2021/Guppy3Guppy5/2021.08.17_NAPA/Indel_Xtrization/g5'
    #
    # for sp in species:
    #     out3 = f'{species_ref3_dir}/{sp}/{sp}_g3indelChecked.csv'
    #     out5 = f'{species_ref5_dir}/{sp}/{sp}_g5indelChecked.csv'
    #     run_for_each_guppy(f'{species_ref3_dir}/{sp}/{sp}_g3norm.csv',
    #                        f'{species_ref3_dir}/{sp}/consensus.fasta', 'g3', out3)
    #     run_for_each_guppy(f'{species_ref5_dir}/{sp}/{sp}_g5norm.csv', f'{species_ref5_dir}/{sp}/consensus.fasta', 'g5',
    #                        out5)

    acit = read_in_genome('/Users/malcolmorian/Documents/Bioinformatics/Projects2021/Guppy3Guppy5/2021.08.17_NAPA/Indel_Xtrization/g3/1_Acinetobacter_baumannii_J9/consensus.fasta')

    print(acit['contig_3'][4325:4346])

if __name__ == '__main__':
    main()


