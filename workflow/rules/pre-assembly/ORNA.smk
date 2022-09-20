rule ORNA:
    input:
        expand("{{path}}/pooled/pooled_{pair}.fq.gz", pair=[1, 2])
    output:
        expand("{{path}}/pooled/ORNA/pooled_{pair}.fq", pair=[1, 2]),
        temp(expand("{{path}}/pooled/ORNA/pooled_Sorted_{pair}.fq", pair=[1, 2]))
    log:
        "{path}/pooled/ORNA/logs/main.log"
    params:
        kmer=config["ORNA"]["kmer"]
    conda:
        "../../envs/ORNA.yaml"
    shadow:
        "minimal"
    shell:
        "ORNA -sorting 1 -kmer {params.kmer} -pair1 {input[0]:q} -pair2 {input[1]:q} -type fq"
        " -output {wildcards.path:q}/pooled/ORNA/pooled &> {log:q} && rmdir {wildcards.path:q}/pooled/ORNA/tmp"
