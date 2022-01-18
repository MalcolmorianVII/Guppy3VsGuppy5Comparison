#! /home/belson/anaconda3/bin/python
import glob
import csv
import os
import click

@click.group(chain=True)
def cli():
    pass
@click.command()
@click.option('--input_dir', '-i', help='Takes in root directory which contains results for all the  8 species')
@click.option('--output_dir', '-o', help='Outputs a csv file with  the following columns ')
def preparator(*input_dir,output_dir):
    """
    Takes in 2 vcf files i.e vcf3 & vcf5 as inputs & bgzip & tabix them
    """
    gzipped = []
    for vcf in input_dir:
        print(f'------- STARTED BGZIPPING & TABINDEXING {vcf} ----------')
        os.system(f'bgzip {vcf} && tabix {vcf}.gz')
        print(f'BGZIPPING & TABINDEXING finished')
        gzipped.append(f'{vcf}.gz')
    return gzipped

@click.command()
@click.option('--output_dir', '-o', help='Outputs a csv file with  the following columns ')
def intersector(output_dir):
    """
    Takes in two vcf files i.e vcf3 & vcf5 files as inputs( bgziped & tabixed) & performs the intersection & union of
    them
    """
    #preparator()
    ins = ' '.join(preparator) # combines the two vcf files into one string which is space separated
    os.system(f'bcftools isec -p {output_dir} {ins}')
    return output_dir
#
#def generator(output_dir):
#    """
#    Takes in results directory & creates a table for intersection,complements(both g3 & g5) into one text file(tsv)
#
#    HINT:
#    0000.VCF = G3 (G5 COMPLEMENT)
#    0001.VCF = G5 (G3 COMPLEMENT)
#    0002.VCF & 0003.VCF = INTERSECTION(G3 & G5)
#    """
#    FILES_TO_READ = ['0000.vcf','0001.vcf','0002.vcf']
#    var_vals = []
#
#    for file in FILES_TO_READ:
#        count = ''
#        os.system(f'{count}=`grep -v "^#" {output_dir}/{file} | wc -l`')
#        var_vals.append(count)
#
#    with open(f'{output_dir}/vcfIntersects_complements.csv','wt') as file:
#        csvwriter = csv.writer(file,delimeter='\t')
#        csvwriter.writerow(['SPECIES','TOOL','G3','G5','Intersection'])
#        csvwriter.writerow(var_vals)
#
#out = intersector()
#generator(out)





