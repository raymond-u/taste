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
    threads:
        8
    run:
        command = "fastp -i {input[0]:q} -I {input[1]:q} -o {output[0]:q} -O {output[1]:q} -w {threads}"
        
        if config["fastp"]["correct_mismatches"]:
            command += " -c"
        if config["fastp"]["filter_low_complexity"]:
            command += " -y"
        
        # always trim poly-G since some RNA-seq data do not have an Illumina tag
        command += " --detect_adapter_for_pe -g -l 25 -h {log.html:q} -j {log.json:q} 2> {log.main:q}"
        
        shell(command)
