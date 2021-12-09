chrom = '/Users/malcolmorian/Documents/Bioinformatics/Projects2021/Guppy3Guppy5/NOSC/nosc/Acinetobacter_chromosome.fasta'
out = '/Users/malcolmorian/Documents/Bioinformatics/Projects2021/Guppy3Guppy5/NOSC/nosc/acineto_chunks'
with open(chrom,'r') as f:
    chro = f.readlines()[-1]
    c = 0
    i = 1
    while c < len(chro):
        chunk = chro[c:c+100000]
        with open(f'{out}/chunk{i}','w') as file:
            file.write(chunk)
        c += 100000
        i += 1

print('Done')
