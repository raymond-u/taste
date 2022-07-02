import json

wildcard_constraints:
    run_number="[A-Z]RR[0-9]+"

rule rcorrector:
    input:
        expand("{{path}}/fastp/{{run_number}}_{pair}.fq.gz", pair=[1, 2])
    output:
        temp(expand("{{path}}/rcorrector/{{run_number}}_{pair}.cor.fq.gz", pair=[1, 2]))
    params:
        path=config["rcorrector"]["path"]
    log:
        "{path}/rcorrector/logs/{run_number}.log"
    threads:
        8
    shadow:
        "minimal"
    shell:
        "perl {params.path:q}/run_rcorrector.pl -1 {input[0]:q} -2 {input[1]:q} -od {wildcards.path:q}/rcorrector/ -t {threads} 2> {log:q}"

rule rcorrector_cleanup:
    input:
        expand("{{path}}/rcorrector/{{run_number}}_{pair}.cor.fq.gz", pair=[1, 2])
    output:
        temp(expand("{{path}}/rcorrector/{{run_number}}_{pair}.fin.fq.gz", pair=[1, 2]))
    log:
        "{path}/rcorrector/logs/{run_number}_fin.log"
    conda:
        "../../envs/rust-script.yaml"
    script:
        "../../scripts/rcorrector_cleanup.rs"
        # old python script
        #data = {"input": list(input), "output": list(output), "log": log[0]}
        #shell(f"pypy3 workflow/scripts/rcorrector_cleanup.py '{json.dumps(data).replace('{', '{{').replace('}', '}}')}'")
