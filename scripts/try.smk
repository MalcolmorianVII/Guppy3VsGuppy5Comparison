configfile:"try.yaml"
root_dir = config["to_run"]
samples = config["samples"]
model = config["model"]

rule all:
	input:
		expand("{results}/{sample}/{sample}flye",sample = samples,results = results)

rule flye:
	input:
		expand("{root_dir}/barcode0{{sample}}.fastq.gz",root_dir=root_dir,sample=samples)
	output:
		directory("{results}/{sample}/{sample}flye")
	shell:
        """
        conda activate flye
		flye --nano-hq {output} -g 5m -o {input.nano} -t 8
        """