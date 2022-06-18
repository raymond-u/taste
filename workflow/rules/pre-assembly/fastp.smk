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
        # always trim poly-G since some RNA-seq data do not have an Illumina tag
        command = "fastp -i {input[0]} -I {input[1]} -o {output[0]} -O {output[1]} -h {log.html} -j {log.json} -w {threads}"

        if config["fastp"]["correct_mismatches"]:
            command += " -c"
        if config["fastp"]["filter_low_complexity"]:
            command += " -y"
        
        command += " --detect_adapter_for_pe -g -l 25 2> {log.main}"

        shell(command)
