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
        2
    shell:
        "mkdir -p {wildcards.path}/fastqc/pre && fastqc --noextract -o {wildcards.path}/fastqc/pre" \
        " -t {threads} -d {wildcards.path}/fastqc/pre {input[0]} {input[1]} 2> {log}"

rule fastqc_post:
    input:
        expand("{{path}}/sortmerna/{{run_number}}_{pair}.fq.gz", pair=[1, 2])
    output:
        expand("{{path}}/fastqc/post/{{run_number}}_{pair}_fastqc.html", pair=[1, 2])
    log:
        "{path}/fastqc/post/logs/{run_number}.log"
    threads:
        2
    shell:
        "mkdir -p {wildcards.path}/fastqc/post && fastqc --noextract -o {wildcards.path}/fastqc/post" \
        " -t {threads} -d {wildcards.path}/fastqc/post {input[0]} {input[1]} 2> {log}"
