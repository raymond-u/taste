def get_arguments(_):
    arguments = ""
    
    ref = config["sortmerna"]["ref_path"]
    
    if config["sortmerna"]["use_5.8s"]:
        arguments += f" --ref {ref}/rfam-5.8s-database-id98.fasta"
    if config["sortmerna"]["use_5s"]:
        arguments += f" --ref {ref}/rfam-5s-database-id98.fasta"
    if config["sortmerna"]["use_arc_16s"]:
        arguments += f" --ref {ref}/silva-arc-16s-id95.fasta"
    if config["sortmerna"]["use_arc_23s"]:
        arguments += f" --ref {ref}/silva-arc-23s-id98.fasta"
    if config["sortmerna"]["use_bac_16s"]:
        arguments += f" --ref {ref}/silva-bac-16s-id90.fasta"
    if config["sortmerna"]["use_bac_23s"]:
        arguments += f" --ref {ref}/silva-bac-23s-id98.fasta"
    if config["sortmerna"]["use_euk_18s"]:
        arguments += f" --ref {ref}/silva-euk-18s-id95.fasta"
    if config["sortmerna"]["use_euk_28s"]:
        arguments += f" --ref {ref}/silva-euk-28s-id98.fasta"
    
    return arguments

wildcard_constraints:
    run_number="[A-Z]RR[0-9]+"

rule sortmerna:
    input:
        expand("{{path}}/rcorrector/{{run_number}}_{pair}.fin.fq.gz", pair=[1, 2])
    output:
        expand("{{path}}/sortmerna/{{run_number}}_{pair}.fq.gz", pair=[1, 2])
    log:
        "{path}/sortmerna/logs/{run_number}.log"
    params:
        prefix="{path}/sortmerna/{run_number}",
        arguments=get_arguments
    threads:
        8
    conda:
        "../../envs/sortmerna.yaml"
    shell:
        # always try to clean working directory or sortmerna might complain
        "rm -rf {params.prefix:q} && sortmerna --reads {input[0]:q} --reads {input[1]:q} --workdir {params.prefix:q}/"
        " {params.arguments} --threads {threads} --num_alignments 1 --no-best --fastx --paired_out --out2"
        " --aligned {params.prefix:q}_rRNA --other {params.prefix:q} &> {log:q} && rename s/fwd/1/ {params.prefix:q}*.gz"
        " && rename s/rev/2/ {params.prefix:q}*.gz && mv -f {params.prefix:q}_rRNA.log {wildcards.path:q}/sortmerna/logs"
