rule transrate:
    input:
        assembly="{path}/trinity/trinity.fasta",
        reads=expand("{{path}}/pooled_{pair}.fq.gz", pair=[1, 2])
    output:
        "{path}/trinity/transrate/assemblies.csv"
    log:
        "{path}/trinity/transrate/logs/main.log"
    threads:
        8
    shell:
        "transrate --assembly={input.assembly:q} --left={input.reads[0]:q} --right={input.reads[1]:q}" \
        " --threads={threads} --output={wildcards.path:q}/trinity/transrate 2> {log:q}"
