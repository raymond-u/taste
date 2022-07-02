from pathlib import Path

def get_reports_input(wildcards):
    inputs = []
    
    for path in Path(wildcards.path).glob("*/*_1.fastq.gz"):
        inputs.append(str(path.parent.joinpath("fastp", "logs", path.name[:-11] + ".json")))
    
    return inputs

rule soapdenovotrans_config:
    input:
        reads=expand("{{path}}/pooled/ORNA/pooled_{pair}.fq", pair=[1, 2]),
        reports=get_reports_input
    output:
        "{path}/pooled/soapdenovotrans/pooled.config"
    script:
        "../../scripts/make_soapdenovotrans_config.py"

rule soapdenovotrans:
    input:
        "{path}/pooled/soapdenovotrans/pooled.config"
    output:
        "{path}/pooled/soapdenovotrans/assembly_k{kmer}.scafSeq"
    log:
        "{path}/pooled/soapdenovotrans/logs/assembly_k{kmer}.log"
    threads:
        8
    shell:
        "mkdir -p {wildcards.path}/pooled/soapdenovotrans/k{wildcards.kmer} && SOAPdenovo-Trans-127mer all -s {input}" \
        " -o {wildcards.path}/pooled/soapdenovotrans/k{wildcards.kmer}/fin -F -K {wildcards.kmer} -p {threads} -L 200" \
        " -t 32 2> {log} && mv -f {wildcards.path}/pooled/soapdenovotrans/k{wildcards.kmer}/fin.scafSeq {output}"
