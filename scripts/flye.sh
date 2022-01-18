#! /usr/bin/bash

#NOTE:  $1 = {wildcards.ref}; $2 =  {wildcards.results} $3 = model
set -e
eval "$(conda shell.bash hook)"
conda activate "flye"

mkdir $1 && flye --nano-hq $2 -g 5m -o $1 -t 8 --plasmids
