#! /usr/bin/bash

g3='/home/ubuntu/data/belson/Guppy5_guppy3_comparison/napa/results/2021.08.02/guppy3'
g5='/home/ubuntu/data/belson/Guppy5_guppy3_comparison/napa/results/2021.08.02/guppy5'

vcfIntersects=/home/ubuntu/data/belson/Guppy5_guppy3_comparison/napa/results/2021.09.03
#Normalization first within for loop
mkdir -p $vcfIntersects
printf "g3uniq\tg5uniq\tg3g5intersect\n" > $vcfIntersects/vcfCompas.txt
for dir in $g3/{1..8}*
do
  spec_dir=$(basename $dir)
  g3vcf=$dir/${spec_dir}polishMedaka/consensus.fasta.vcf.gz
  g5vcf=$g5/$spec_dir/${spec_dir}polishMedaka/consensus.fasta.vcf.gz
  norm3=$g3/${spec_dir}/${spec_dir}_indel_norm
  norm5=$g5/${spec_dir}/${spec_dir}_indel_norm
  # Normalizing
  if [[ -d ${norm3} && -d ${norm5} ]]
  then
	echo "Files exist already"
	rm -r ${norm3} ${norm5}
  fi
  mkdir ${norm3} &&  bcftools norm -f $g3/$spec_dir/${spec_dir}medaka/consensus.fasta  $g3vcf -Oz -o ${norm3}/${spec_dir}.norm.vcf.gz && tabix ${norm3}/${spec_dir}.norm.vcf.gz
  mkdir ${norm5} && bcftools norm -f $g5/$spec_dir/${spec_dir}medaka/consensus.fasta  $g5vcf -Oz -o ${norm5}/${spec_dir}.norm.vcf.gz && tabix ${norm5}/${spec_dir}.norm.vcf.gz
#  echo '------- STARTED BGZIPPING & TABINDEXING {vcf} ----------'
#  bgzip  $g3vcf && tabix $g3vcf.gz
#  bgzip $g5vcf && tabix $g5vcf.gz
#  echo 'BGZIPPING & TABINDEXING finished'

 if [ -d $vcfIntersects/${spec_dir} ]
 then 
	echo "Directory exists"
	rm -r $vcfIntersects/${spec_dir}
  fi
 echo '----starting bcftools isec'
 mkdir -p $vcfIntersects/${spec_dir} &&  bcftools isec -p $vcfIntersects/${spec_dir} ${norm3}/${spec_dir}.norm.vcf.gz ${norm5}/${spec_dir}.norm.vcf.gz 
 echo '---FINISHED bcftooling vcfs'
  # MERGING THE COMPLEMENTS & INTERSECT FILES
  g3uniq=$(grep -vc "^#"  $vcfIntersects/${spec_dir}/0000.vcf )
  g5uniq=$(grep -vc "^#" $vcfIntersects/${spec_dir}/0001.vcf )
  g3g5inter=$(grep -vc "^#" $vcfIntersects/${spec_dir}/0002.vcf )

  # ECHO TO OUTPUT FILES
  printf "$spec_dir\t$g3uniq\t$g5uniq\t$g3g5inter\n" >> $vcfIntersects/vcfCompas.txt
  done
