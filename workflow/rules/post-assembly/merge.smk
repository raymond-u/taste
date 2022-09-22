def get_merge_input(wildcards):
    # collect Trinity assembly
    trinity = [f"{wildcards.path}/pooled/trinity/assembly_k25.fa"]
    # collect Trans-ABySS assemblies
    transabyss = [f"{wildcards.path}/pooled/transabyss/assembly_k{kmer}.fa" for kmer in config["transabyss"]["kmers"]]
    # collect SOAPdenovo-Trans assemblies
    soapdenovotrans = [f"{wildcards.path}/pooled/soapdenovotrans/assembly_k{kmer}.scafSeq"
    for kmer in config["soapdenovotrans"]["kmers"]]
    # collect Oases assemblies, +1 to include the upper bound
    oases = [f"{wildcards.path}/pooled/oases/assembly_k{kmer}.fa"
    for kmer in range(config["oases"]["kmer_min"], config["oases"]["kmer_max"] + 1, config["oases"]["kmer_step"])]
    
    return {"trinity": trinity, "transabyss": transabyss, "soapdenovotrans": soapdenovotrans, "oases": oases}

rule merge:
    input:
        unpack(get_merge_input)
    output:
        temp("{path}/pooled/merged/merged.fa")
    log:
        "{path}/pooled/merged/logs/main.log"
    conda:
        "../../envs/rust-script.yaml"
    script:
        "../../scripts/merge.rs"
        # old python script
        #data = {"input": get_merge_input(wildcards), "output": output[0], "log": log[0]}
        #shell("mkdir -p {wildcards.path}/pooled/merged/logs"
        #f" && pypy3 workflow/scripts/merge.py '{json.dumps(data).replace('{', '{{').replace('}', '}}')}'")
