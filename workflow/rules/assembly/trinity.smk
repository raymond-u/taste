rule trinity:
    input:
        expand("{{path}}/pooled/ORNA/pooled_{pair}.fq", pair=[1, 2])
    output:
        "{path}/pooled/trinity/assembly_k25.fa"
    log:
        "{path}/pooled/trinity/logs/assembly_k25.log"
    threads:
        8
    conda:
        "../../envs/trinity.yaml"
    shell:
        "Trinity --seqType fq --max_memory 30G --CPU {threads} --left {input[0]:q} --right {input[1]:q}"
        " --output {wildcards.path:q}/pooled/trinity/trinity_tmp --full_cleanup --no_normalize_reads &> {log:q}"
        " && rename s/trinity_tmp.Trinity.fasta/assembly_k25.fa/ {wildcards.path:q}/pooled/trinity/*"
