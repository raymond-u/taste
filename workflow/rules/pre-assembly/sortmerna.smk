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
        ref=config["sortmerna"]["ref_path"],
        prefix="{path}/sortmerna/{run_number}"
    threads:
        8
    run:
        # always try to clean working directory or sortmerna might complain
        command = "rm -rf {params.prefix:q} && sortmerna --reads {input[0]:q} --reads {input[1]:q} --workdir {params.prefix:q}/"
        
        if config["sortmerna"]["use_5.8s"]:
            command += " --ref {params.ref:q}/rfam-5.8s-database-id98.fasta"
        if config["sortmerna"]["use_5s"]:
            command += " --ref {params.ref:q}/rfam-5s-database-id98.fasta"
        if config["sortmerna"]["use_arc_16s"]:
            command += " --ref {params.ref:q}/silva-arc-16s-id95.fasta"
        if config["sortmerna"]["use_arc_23s"]:
            command += " --ref {params.ref:q}/silva-arc-23s-id98.fasta"
        if config["sortmerna"]["use_bac_16s"]:
            command += " --ref {params.ref:q}/silva-bac-16s-id90.fasta"
        if config["sortmerna"]["use_bac_23s"]:
            command += " --ref {params.ref:q}/silva-bac-23s-id98.fasta"
        if config["sortmerna"]["use_euk_18s"]:
            command += " --ref {params.ref:q}/silva-euk-18s-id95.fasta"
        if config["sortmerna"]["use_euk_28s"]:
            command += " --ref {params.ref:q}/silva-euk-28s-id98.fasta"
        
        command += " --threads {threads} --num_alignments 1 --no-best --fastx --paired_out --out2 --aligned {params.prefix:q}_rRNA" \
        " --other {params.prefix:q} 2> {log:q} && rename s/fwd/1/ {params.prefix:q}*.gz && rename s/rev/2/ {params.prefix:q}*.gz" \
        " && mv -f {params.prefix:q}_rRNA.log {wildcards.path:q}/sortmerna/logs"
        
        shell(command)
