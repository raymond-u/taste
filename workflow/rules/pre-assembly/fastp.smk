def get_arguments(_):
    arguments = ""
    
    if config["fastp"]["correct_mismatches"]:
        arguments += " -c"
    if config["fastp"]["filter_low_complexity"]:
        arguments += " -y"
    
    return arguments

wildcard_constraints:
    run_number="[A-Z]RR[0-9]+"

rule fastp:
    input:
        expand("{{path}}/{{run_number}}_{pair}.fastq.gz", pair=[1, 2])
    output:
        expand("{{path}}/fastp/{{run_number}}_{pair}.fq.gz", pair=[1, 2])
    log:
        main="{path}/fastp/logs/{run_number}.log",
        html="{path}/fastp/logs/{run_number}.html",
        json="{path}/fastp/logs/{run_number}.json"
    params:
        arguments=get_arguments
    threads:
        8
    conda:
        "../../envs/fastp.yaml"
    shell:
        "fastp -i {input[0]:q} -I {input[1]:q} -o {output[0]:q} -O {output[1]:q} -w {threads} {params.arguments}"
        " --detect_adapter_for_pe -g -l 25 -h {log.html:q} -j {log.json:q} &> {log.main:q}"
