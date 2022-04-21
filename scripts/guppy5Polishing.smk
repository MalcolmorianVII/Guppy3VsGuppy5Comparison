configfile:"/home/ubuntu/data/belson/projects/projects_2021/napa/scripts/multi_speciesConfig.yaml"
root_dir = config["to_run"]
samples = config["samples"]
model = config["model"]

rule all:
	input:
		expand("{results}/{sample}/{sample}Flye",sample = samples,results = results),
		expand("{results}/{sample}/{sample}polishFlye",sample = samples,results = results),
		expand("{results}/{sample}/{sample}polishracon1",sample = samples,results = results),
		expand("{results}/{sample}/{sample}medaka",sample = samples,results = results),
		expand("{results}/{sample}/{sample}polishMedaka",sample = samples,results = results),
		expand("{results}/{sample}/{sample}Illumina",results = results,sample=samples),
		expand("{results}/{sample}/{sample}polishIllumina",results = results,sample=samples)

rule flye:
	input:
		expand("{root_dir}/barcode0{{sample}}.fastq.gz",root_dir=root_dir,sample=samples)
	output:
		directory("{results}/{sample}/{sample}Flye")
	conda:
		config["flye"]
	shell:
		"flye --nano-hq {output} -g 5m -o {input.nano} -t 8 --plasmids"

rule polishFlye:
	input:
		gen = rules.flye.output,
		r1 = lambda wildcards : config[wildcards.sample]["R1"],
		r2 = lambda wildcards : config[wildcards.sample]["R2"]
	output:
		directory("{results}/{sample}/{sample}polishFlye")
	shell:
		"""
		polca.sh -a {input.gen}/assembly.fasta -r "{input.r1} {input.r2}"
		mkdir {output} && mv assembly.fasta* {output}
		"""

rule racon1:
	input:
		gen = rules.flye.output,
		nano = reads
	output:
		rac1 = temp("{results}/{sample}/{sample}racon1.fasta"),
		paf1 = temp("{results}/{sample}/{sample}.racon.paf")
	shell:
		"""
		minimap2 -x map-ont {input.gen}/assembly.fasta {input.nano} > {output.paf1}
		racon -t 4 {input.nano} {output.paf1} {input.gen}/assembly.fasta > {output.rac1}
		"""

rule polish_racon1:
	input:
		gen = rules.racon1.output.rac1,
		r1 = lambda wildcards : config[wildcards.sample]["R1"],
		r2 =  lambda wildcards : config[wildcards.sample]["R2"]
	output:
		directory("{results}/{sample}/{sample}polishracon1")
	shell:
		"""
		polca.sh -a {input.gen} -r "{input.r1} {input.r2}"
		mkdir {output} && mv {wildcards.sample}racon1.fasta* {output}
		"""

rule medaka:
	input:
		gen = rules.racon1.output.rac1,
		nano = reads
	output:
		directory("{results}/{sample}/{sample}medaka")
	conda:
		config["medaka"]
	shell:
		"medaka_consensus -i {input.nano} -d {input.gen} -t 8  -m {model} -o {output}"

rule polish_medaka:
        input:
            gen = rules.medaka.output,
			r1 = lambda wildcards : config[wildcards.sample]["R1"],
            r2 =  lambda wildcards : config[wildcards.sample]["R2"]
        output:
            directory("{results}/{sample}/{sample}polishMedaka")
        shell:
			"""
            polca.sh -a {input.gen}/consensus.fasta -r "{input.r1} {input.r2}"
			mkdir {output} && mv consensus.fasta* {output}
			"""

rule spades:
	input:
		R1 = lambda wildcards : config[wildcards.sample]["R1"],
		R2 = lambda wildcards : config[wildcards.sample]["R2"]
	output:
		directory("{results}/{sample}/{sample}Illumina")
	shell:
		"spades.py -1 {input.R1} -2 {input.R2} --phred-offset 33 -o {output}"

rule polish_spades:
	input:
		gen = rules.spades.output,
		r1 = lambda wildcards : config[wildcards.sample]["R1"],
        r2 =  lambda wildcards : config[wildcards.sample]["R2"]
	output:
		directory("{results}/{sample}/{sample}polishIllumina")
	shell:
		"""
		polca.sh -a {input.gen}/contigs.fasta -r "{input.r1} {input.r2}"
		mkdir {output} && mv contigs.fasta* {output}
		"""
