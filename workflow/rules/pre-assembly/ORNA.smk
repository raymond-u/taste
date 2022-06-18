rule ORNA:
    input:
        expand("{{path}}/pooled/pooled_{pair}.fq.gz", pair=[1, 2])
    output:
        expand("{{path}}/pooled/ORNA/pooled_{pair}.fq", pair=[1, 2])
    log:
        "{path}/pooled/ORNA/logs/main.log"
    params:
        kmer=config["ORNA"]["kmer"]
    shadow:
        "minimal"
    shell:
        "ORNA -sorting 1 -kmer {params.kmer} -pair1 {input[0]} -pair2 {input[1]} -output {wildcards.path}/pooled/ORNA/pooled" \
        " -type fq 2> {log}"
