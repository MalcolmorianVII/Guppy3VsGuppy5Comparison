#! /usr/bin/bash

g3='/home/ubuntu/data/belson/Guppy5_guppy3_comparison/napa/results/2021.08.02/guppy3'
g5='/home/ubuntu/data/belson/Guppy5_guppy3_comparison/napa/results/2021.08.02/guppy5'

vcfIntersects=/home/ubuntu/data/belson/Guppy5_guppy3_comparison/napa/results/2021.09.03
mkdir -p $vcfIntersects
printf "g3uniq\tg5uniq\tg3g5intersect\n" > $vcfIntersects/vcfCompas.txt
for dir in $g3/{1..8}*
do
  spec_dir=$(basename $dir)
  g3vcf=$dir/${spec_dir}polishMedaka/consensus.fasta.vcf
  g5vcf=$g5/$spec_dir/${spec_dir}polishMedaka/consensus.fasta.vcf
  echo '------- STARTED BGZIPPING & TABINDEXING {vcf} ----------'
  bgzip  $g3vcf && tabix $g3vcf.gz
  bgzip $g5vcf && tabix $g5vcf.gz
  echo 'BGZIPPING & TABINDEXING finished'

  echo '----starting bcftools isec'
  bcftools isec -p $vcfIntersects  $g3vcf.gz $g5vcf.gz
  echo '---FINISHED bcftooling vcfs'

  # MERGING THE COMPLEMENTS & INTERSECT FILES
  g3uniq=$(grep -vc "^#"  $vcfIntersects/0000.vcf )
  g5uniq=$(grep -vc "^#" $vcfIntersects/0001.vcf )
  g3g5inter=$(grep -vc "^#" $vcfIntersects/0002.vcf )

  # ECHO TO OUTPUT FILES
  printf "$spec_dir\t$g3uniq\t$g5uniq\t$g3g5inter\n" >> $vcfIntersects/vcfCompas.txt
  done
