rule MCSC:
    input:
        "{path}/pooled/trinity/Trinity.fasta"
    output:
        "{path}/pooled/MCSC/Trinity_decont.fasta"
    log:
        "{path}/pooled/MCSC/logs/main.log"
    params:
        taxon_level=config["MCSC"]["taxon_level"],
        target_taxon=config["MCSC"]["target_taxon"],
        path=config["MCSC"]["path"],
        dump_folder=config["MCSC"]["dump_folder"],
        uniref90_path=config["MCSC"]["uniref90_path"],
        uniref100_path=config["MCSC"]["uniref100_path"]
    threads:
        8
    shell:
        "sh {params.path:q}/MCSC_decontamination.sh -i {input:q} -o {wildcards.path:q}/pooled/MCSC -l {params.taxon_level:q}" \
        " -n {params.target_taxon:q} -b {params.path:q} -d {params.dump_folder:q} -u {params.uniref90_path:q}" \
        " -x {params.uniref100_path:q} -t {threads} 2> {log:q}"
