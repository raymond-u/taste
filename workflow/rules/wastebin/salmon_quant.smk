wildcard_constraints:
    tissue="[^/]+",
    run_number="[A-Z]RR[0-9]+"

rule salmon_quant:
    input:
        index="{path}/pooled/salmon/index/versionInfo.json",
        reads=expand("{{path}}/{{tissue}}/sortmerna/{{run_number}}_{pair}.fq.gz", pair=[1, 2])
    output:
        "{path}/{tissue}/salmon/{run_number}/aux_info/eq_classes.txt"
    log:
        "{path}/{tissue}/salmon/{run_number}/logs/main.log"
    threads:
        8
    shell:
        "salmon quant -i {wildcards.path}/pooled/salmon/index -l A -1 {input.reads[0]} -2 {input.reads[1]} -p {threads}" \
        " --skipQuant --dumpEq --hardFilter -o {wildcards.path}/{wildcards.tissue}/salmon/{wildcards.run_number} 2> {log}"
