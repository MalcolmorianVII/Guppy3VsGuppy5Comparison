configfile:"/home/ubuntu/data/belson/Guppy5_guppy3_comparison/nosc_clair/scripts/g3_g5Config.yaml"
refs = ['Acinetobacter_baumannii','Citrobacter_koseri','Enterobacter_kobei','Haemophilus_sp','Klebsiella_oxytoca','Salmonella_enterica','Klebsiella_variicola','Serratia_marcescens']
results = '/home/ubuntu/data/belson/Guppy5_guppy3_comparison/nosc_clair/results/2021.05.08/' + config['g'] # Check folder
#root_dir = config['torun']
m = config['model']
def reads(wildcards):
        return expand('{read}',read=config[wildcards.ref][config['g']])
rule all:
	input:
		expand('{results}/{ref}/{ref}_nosc.clair.fasta',results = results,ref = refs)
rule minimap:
	input:
		ref = expand('/home/ubuntu/data/belson/Guppy5_guppy3_comparison/reference_genomes/{{ref}}.fna',ref=refs),
		nano = reads
	output:
		temp('{results}/{ref}.sam')
	shell:
		'minimap2 -ax map-ont {input.ref} {input.nano} > {output}'

rule sortBam:
	input:
		rules.minimap.output
	output:
		temp('{results}/{ref}/{ref}.sorted.bam')
	shell:
		'samtools sort -@ 8 -o {output} {input} && samtools index {output}'
rule clair:
	input:
		rules.sortBam.output
	output:
		'{results}/{ref}/{ref}_nosc.clair.fasta'
	shell:
		'./clair.sh {wildcards.ref} {wildcards.results} {m}'
#rule clairPolca:
#	input:
#		gen = rules.clair.output,
#		r1 = expand('{sampleDir}/{r1}',sampleDir=sampleDir,r1=config["illumina"][0]),
#                r2 = expand('{sampleDir}/{r2}',sampleDir=sampleDir,r2=config["illumina"][1])
#	output:
#		directory('{results}/{ref}ClairPolca')
#	shell:
#		"polca.sh -a {input.gen} -r '{input.r1} {input.r2}' && mkdir {output} && mv {wildcards.ref}_flye.clair.fasta* {output}"	
	
