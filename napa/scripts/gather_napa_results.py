#! /home/belson/anaconda3/bin/python
import glob
import csv
import os
import click


@click.command()
@click.option('--input_dir', '-i', help='Takes in root directory which contains results for all the  8 species')
@click.option('--output_dir', '-o', help='Outputs a csv file with  the following columns ')
@click.option('--guppy_version','-g',help='Specify the guppy version of the data')
def aggregator(input_dir, output_dir,guppy_version):
    species = os.listdir(input_dir)
    abs_path = os.path.abspath(input_dir) + '/'
    #       print(abs_path)
    with open(output_dir, 'w') as out:
        writer = csv.writer(out, delimiter='\t')
        writer.writerow(['Species', 'GuppyVersion','Tool', 'Substitution_Errors', 'Indels', 'Consensus_Quality'])
        for specie in species:
            #base = f'{abs_path + specie}'
            tools = ['Flye', 'Medaka']
            base = '/home/ubuntu/data/belson/Guppy5_guppy3_comparison/napa/results/2021.08.02/guppy3/1_Acinetobacter_baumannii_J9'
            reports = {i:glob.glob(f'{abs_path + specie}/*polish{tool}/*report')[0] for tool in tools}
            #dirs = glob.glob(f/*polish{Flye,Medaka}/*report')
            #print(dirs)
            for report in reports:
                metrics = reader(reports[report])
                writer.writerow([specie, 'guppy_' + guppy_version, key, metrics[0], metrics[1], metrics[2]])
#            with open(dirs[0], 'r') as f:
#                lines = f.readlines()
#                sub = lines[0].split(':')[1].strip()
#                indels = lines[1].split(':')[1].strip()
#                qscore = lines[3].split(':')[1].strip()
#                writer.writerow([specie,'guppy_' + guppy_version, 'Medaka', sub, indels, qscore])

#aggregator()

def reader(file):
    with open(file, 'r') as f:
               lines = f.readlines()
               sub = lines[0].split(':')[1].strip()
               indels = lines[1].split(':')[1].strip()
               qscore = lines[3].split(':')[1].strip()
               return (sub,indels,qscore)

aggregator()
