from pathlib import Path

def get_pool_input(wildcards):
    forward_reads = []
    reverse_reads = []
    
    for path in Path(wildcards.path).glob("*/*_1.fastq.gz"):
        forward_reads.append(str(path.parent.joinpath("sortmerna", path.name[:-10] + "1.fq.gz")))
        reverse_reads.append(str(path.parent.joinpath("sortmerna", path.name[:-10] + "2.fq.gz")))
    
    return {"forward_reads": forward_reads, "reverse_reads": reverse_reads}

rule pool:
    input:
        unpack(get_pool_input)
    output:
        temp(expand("{{path}}/pooled/pooled_{pair}.fq.gz", pair=[1, 2]))
    run:
        "cat {input.forward_reads} > {output[0]} && cat {input.reverse_reads} > {output[1]}"
