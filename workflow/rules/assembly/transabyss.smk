rule transabyss:
    input:
        expand("{{path}}/pooled/ORNA/pooled_{pair}.fq", pair=[1, 2])
    output:
        "{path}/pooled/transabyss/assembly_k{kmer}.fa"
    log:
        "{path}/pooled/transabyss/logs/assembly_k{kmer}.log"
    threads:
        8
    conda:
        config["transabyss"]["conda_name"]
    shell:
        # set tmpdir for ABySS
        "export TMPDIR={wildcards.path}/pooled/transabyss/k{wildcards.kmer}_tmp && transabyss --pe {input.[0]} {input.[1]}" \
        " --outdir {wildcards.path}/pooled/transabyss/k{wildcards.kmer} --length 200 --threads {threads} -k {wildcards.kmer}" \
        " 2> {log} && mv -f {wildcards.path}/pooled/transabyss/k{wildcards.kmer}/transabyss-final.fa {output}"
