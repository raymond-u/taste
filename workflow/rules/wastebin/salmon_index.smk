rule salmon_index:
    input:
        "{path}/pooled/MCSC/Trinity_decont.fasta"
    output:
        "{path}/pooled/salmon/index/versionInfo.json"
    log:
        "{path}/pooled/salmon/logs/main.log"
    threads:
        8
    shell:
        "salmon index -i {wildcards.path}/pooled/salmon/index -t {input} --tmpdir {wildcards.path}/pooled/salmon/caches" \
        " -p {threads} 2> {log}"
