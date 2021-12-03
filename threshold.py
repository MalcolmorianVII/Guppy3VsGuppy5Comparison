import pandas as pd, os, csv
import pprint, itertools

# Input : pep & gatk vcfs i.e. originated with illumina reads

base = "/Users/malcolmorian/Documents/Bioinformatics/Projects2021/Guppy3Guppy5/NOSC/nosc/Artificial"
pep_df = pd.read_excel(f'{base}/pepper.xlsx', engine='openpyxl')

gatk_df = pd.read_excel(f'{base}/gatk.xlsx', engine='openpyxl')


def add_rpqa(df):
    df['RPAQ'] = ""
    for index, row in df.iterrows():
        rfpsa = row['Ref_pos_alt'], row['QUAL']
        df['RPAQ'][index] = tuple(rfpsa, )
    return df


def generate_vcf_chunks(gen_len,chunk_length):
    half = int(gen_len / 2)
    train_pos = set(range(1, (half + 1)))
    # test_pos = set(range((half+1),gen_len+1))
    i = 0
    train = []
    for q in range(19):
        # print(i)
        sub = tuple(itertools.islice(train_pos, i, i + chunk_length), )
        train.append(sub)
        i += chunk_length
    return train


pep_df = add_rpqa(pep_df)

gatk_df = add_rpqa(gatk_df)

gen_len = 50

gatk_vars = set(gatk_df['Ref_pos_alt'])

pep_qs = set(pep_df['QUAL'])

pep_vars = set(pep_df['RPAQ'])

train = generate_vcf_chunks(gen_len,5)

train = set(value for x in train for value in x)

# print(len(train))
def get_roc_values(test, gatk_vars):
    output = {}
    for quality in range(100):
        # print()
        # print(quality)
        positives = [x for x in test if x[1] >= quality]
        # print(positives)
        neg = [x for x in test if x[1] < quality]  # this isn't all your negatives

        tp = len([x for x in positives if x[0] in gatk_vars])
        # print(tp)
        fp = len([x for x in positives if x[0] not in gatk_vars])
        all_negatives = gen_len - len(positives)
        fn = len(gatk_vars) - tp
        tn = all_negatives - fn
        tpr = tp / (tp + fn)
        fpr = fp / (fp + tn)
        output[quality] = (fpr, tpr)
    return output
#
#
def write_roc(out_dict, chunk):
    with open(f"{base}/test{chunk}_roc_curve.csv", 'w') as f:
        writer = csv.writer(f)
        writer.writerow(['Threshold', 'fpr', 'tpr'])
        for q in out_dict:
            writer.writerow([q, out_dict[q][0], out_dict[q][1]])

#
# # write_roc(g)
#
#
def generate_roc_values(train):
    # out = {}
    pep_vars_train = [x for x in pep_vars if int(x[0].rstrip('ATCGN-,').lstrip('ATCGN-,')) in train]
    roc_values = get_roc_values(pep_vars_train, gatk_vars)
        # out.update(roc_values)
    write_roc(roc_values, f"TestArtificial")
    print('Finished generating roc values')

    # return out
#
#
generate_roc_values(train)
#
#
#
# out_df = pd.DataFrame(a.items(), columns=['fpr', 'tpr'])
#
# print(out_df)

# pep_vars_train = [x for x in pep_vars if int(x[0].rstrip('ATCGN-,').lstrip('ATCGN-,')) in train_pos]
# pep_vars_test = [x for x in pep_vars if int(x[0].rstrip('ATCGN-,').lstrip('ATCGN-,')) in test_pos]


# print(f"Length of pep_vars: {len(pep_vars_train)}")
# print(f"Length of pep_vars: {len(pep_vars_test)}")

# pprint.pprint(gatk_vars)
# pprint.pprint(pep_vars)

# g = get_roc_values(pep_vars_train, gatk_vars)
