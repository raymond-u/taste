from pathlib import Path

rule evigene_tr2aacds:
    input:
        "{path}/pooled/merged/merged.fa"
    output:
        "{path}/pooled/evigene/merged.trclass"
    log:
        main="{path}/pooled/evigene/logs/main.log",
        tr2aacds="{path}/pooled/evigene/logs/tr2aacds.log"
    params:
        path=config["evigene"]["path"],
        species=f"{Path(path).parts[-3]}_{Path(path).parts[-2]}"
    threads:
        8
    shell:
        # tr2aacds.pl is a soft link to the most recent stable release
        # TODO where is output
        "export EVIGENES={params.path:q}/scripts && perl $EVIGENES/prot/tr2aacds.pl -NCPU {threads} -MAXMEM 3000" \
        " -cdnaseq {input:q} -species {params.species:q} -aconsensus (?:trinity|transabyss|soapdenovotrans|oases)\\|k\\d+" \
        " -reorient -logfile {log.tr2aacds:q} 2> {log.main:q}"
