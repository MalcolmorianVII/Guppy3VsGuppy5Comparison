#! /usr/bin/bash
eval "$(conda shell.bash hook)"
conda activate "snakemake"

db_path='/home/ubuntu/data/belson/bacteria-refseq/'
samples='/home/ubuntu/data/belson/Guppy5_guppy3_comparison/napa/results/2021.08.02/guppy3'
for sample in $samples/*
do
	name=`basename $sample`
	referenceseeker $db_path $sample/*Illumina/contigs.fasta | tee /home/ubuntu/data/belson/Guppy5_guppy3_comparison/nosc_clair/results/Refseeker/${name}Refseeker.txt
done

echo "Done just like that Malcolm"


