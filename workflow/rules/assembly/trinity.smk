rule trinity:
    input:
        expand("{{path}}/pooled/ORNA/pooled_{pair}.fq", pair=[1, 2])
    output:
        "{path}/pooled/trinity/assembly_k25.fa"
    log:
        "{path}/pooled/trinity/logs/assembly_k25.log"
    params:
        singularity_binding=config["singularity_binding"],
        path=config["trinity"]["path"]
    threads:
        8
    shell:
        "singularity exec -B {params.singularity_binding} -e {params.path} Trinity --seqType fq --max_memory 30G --CPU {threads}" \
        " --left {input[0]} --right {input[1]} --output {wildcards.path}/pooled/trinity/trinity_tmp --full_cleanup" \
        " --no_normalize_reads 2> {log} && rename s/trinity_tmp.Trinity.fasta/assembly_k25.fa/ {wildcards.path}/pooled/trinity/*"
