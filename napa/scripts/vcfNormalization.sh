#! /usr/bin/bash
species=(1_Acinetobacter_baumannii_J9 2_Citrobacter_koseri_MINF_9D 3_Enterobacter_kobei_MSB1_1B 4_Haemophilus_unknown_M1C132_1 5_Klebsiella_oxytoca_MSB1_2C 6_CHF10J 7_Klebsiella_variicola_INF345 8_Serratia_marcescens_17-147-1671)

g3='/home/ubuntu/data/belson/Guppy5_guppy3_comparison/napa/results/2021.08.02/guppy3'
g5='/home/ubuntu/data/belson/Guppy5_guppy3_comparison/napa/results/2021.08.02/guppy5'

#Pseudo....
# BUT 1st CHECK!!! source file is tabixed $ bgzipped 
# Normalization 1st -----> func1
# Isecalization ------> func2
# Result compilation for Jaccard Indexing ------> func3
#....

# vcfIntersects=/home/ubuntu/data/belson/Guppy5_guppy3_comparison/napa/results/2021.09.03

# mkdir -p ${vcfIntersects}
# printf "g3uniq\tg5uniq\tg3g5intersect\n" > ${vcfIntersects}/vcfCompas.txt

tab_bgzipping () {
  # $1 ${vcf_file}
   echo "------- STARTED BGZIPPING & TABINDEXING ${1} ----------"
   bgzip  $1 && tabix ${1}.gz
   echo "------- BGZIPPING & TABINDEXING finished ------------"
}

indel_vcf_check () {
  # $1: ${vcf_file}

  if [[ -f "${1}.gz" && -f "${1}.gz.tbi" ]]
  then
    echo "File bgzipped & tabindexed....Proceeding to normalization"

  else
    echo "File not bgzipped...Attempting it now"
    if  [ -f "${1}.gz.tbi" ]
    then
      rm "${1}.gz.tbi"
    fi
    tab_bgzipping ${1}
  fi

}


file_existence_checker () {
  # If dir already exist --> previous abortive run ---> re-run TODO:Handle non-rm
  # $1 : assumed files

  if [ -d $1 ]
  then
  echo "Files exist already"
  rm -r ${normalized} ${norm5}
  fi
}

indels_normalizer () {
  # $1 for g3 or g5 dir
  # $2 for guppy version
  # ${3} for species_dir
  vcf_file=${1}/${3}/${3}polishMedaka/consensus.fasta.vcf
  guppy_version=$( basename $2 )

  indel_vcf_check ${vcf_file}
  echo "---- Started normalizing indels for ${guppy_version} ----"

  # indel_vcf=$1/${3}/${3}polishMedaka/consensus.fasta.vcf.gz
  normalized=$1/${3}/${3}_indel_norm.vcf.gz
  file_existence_checker ${normalized}

  bcftools norm -f $1/${3}/${3}medaka/consensus.fasta  ${vcf_file}.gz -Oz -o ${normalized} && tabix ${normalized}
  echo "---- Malcolm issue CODE X0: Normalizing indels for ${guppy_version} data successful ----"
}


data_traversal () {
  # $1 for g3 or g5 dir
  guppy_version=$( basename $1 )
  for species_dir in ${species[@]}

  do
    indels_normalizer $1 ${guppy_version} ${species_dir}
    #bcf_isecalization "${species_dir}" 
  done

}


#data_traversal ${g5} 
data_traversal ${g3}
#Isecalization

# bcf_isecalization () {
#   # $1 guppy version --- globally defined???
#   # Split fxn i.e nested calling with dir traversal logic
#   file_existence_checker "${vcfIntersects}"

#   echo "----starting bcftools isec for ${1}"
#     #vars {species_dir,normalized} globally defined????
#   mkdir -p ${vcfIntersects}/${1} &&  bcftools isec -p ${vcfIntersects}/${1} ${normalized}/${3}.norm.vcf.gz ${norm5}/${3}.norm.vcf.gz 
#  echo "---finished bcftooling ${3} ---"

# }

# compile_for_JI () {

#   # MERGING THE COMPLEMENTS & INTERSECT FILES
#   g3uniq=$(grep -vc "^#"  ${vcfIntersects}/${3}/0000.vcf )
#   g5uniq=$(grep -vc "^#" ${vcfIntersects}/${3}/0001.vcf )
#   g3g5inter=$(grep -vc "^#" ${vcfIntersects}/${3}/0002.vcf )
#   # Save to file
#   printf "$species_dir\t$g3uniq\t$g5uniq\t$g3g5inter\n" >> ${vcfIntersects}/vcfCompas.txt
# }





