from skbio import Sequence
from skbio import read
from skbio import DNA
from io import StringIO
file = ''
# from Bio import SeqIO

# genome = SeqIO.parse(file)
open_filehandle = StringIO('(a, b);')

dna = read(open_filehandle, format='DNA', into=DNA)



seq = Sequence(dna)
for kmer in seq.iter_kmers(100000, overlap=False):
    for d in range(1,41):
        with open(f'chunk{d}.fasta','w') as chunk:
            chunk.write(str(kmer))


