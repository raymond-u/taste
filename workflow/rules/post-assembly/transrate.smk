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
        "transrate --assembly={input.assembly} --left={input.reads[0]} --right={input.reads[1]}" \
        " --threads={threads} --output={wildcards.path}/trinity/transrate 2> {log}"
