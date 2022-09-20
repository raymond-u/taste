wildcard_constraints:
    run_number="[A-Z]RR[0-9]+"

rule fastqc_pre:
    input:
        expand("{{path}}/{{run_number}}_{pair}.fastq.gz", pair=[1, 2])
    output:
        expand("{{path}}/fastqc/pre/{{run_number}}_{pair}_fastqc.html", pair=[1, 2])
    log:
        "{path}/fastqc/pre/logs/{run_number}.log"
    threads:
        4
    conda:
        "../../envs/fastqc.yaml"
    shell:
        "mkdir -p {wildcards.path:q}/fastqc/pre && fastqc --noextract -o {wildcards.path:q}/fastqc/pre"
        " -t {threads} -d {wildcards.path:q}/fastqc/pre {input[0]:q} {input[1]:q} &> {log:q}"

rule fastqc_post:
    input:
        expand("{{path}}/sortmerna/{{run_number}}_{pair}.fq.gz", pair=[1, 2])
    output:
        expand("{{path}}/fastqc/post/{{run_number}}_{pair}_fastqc.html", pair=[1, 2])
    log:
        "{path}/fastqc/post/logs/{run_number}.log"
    threads:
        4
    conda:
        "../../envs/fastqc.yaml"
    shell:
        "mkdir -p {wildcards.path:q}/fastqc/post && fastqc --noextract -o {wildcards.path:q}/fastqc/post"
        " -t {threads} -d {wildcards.path:q}/fastqc/post {input[0]:q} {input[1]:q} &> {log:q}"
