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
        "../../envs/transabyss.yaml"
    shell:
        # set tmpdir for ABySS
        "mkdir -p {wildcards.path:q}/pooled/transabyss/k{wildcards.kmer}_tmp && export"
        " TMPDIR={wildcards.path:q}/pooled/transabyss/k{wildcards.kmer}_tmp && transabyss --pe {input[0]:q} {input[1]:q}"
        " --outdir {wildcards.path:q}/pooled/transabyss/k{wildcards.kmer} --length 200 --threads {threads} -k {wildcards.kmer}"
        " &> {log:q} && mv -f {wildcards.path:q}/pooled/transabyss/k{wildcards.kmer}/transabyss-final.fa {output:q}"
