from pathlib import Path

def get_corset_input(wildcards):
    inputs = []

    for path in Path(wildcards.path).glob("*/*_1.fastq.gz"):
        inputs.append(str(path.parent.joinpath("salmon", path.name[:-11] + "/aux_info/eq_classes.txt")))

    return inputs

rule corset:
    input:
        get_corset_input
    output:
        "{path}/pooled/corset/output-clusters.txt"
    log:
        "{path}/pooled/corset/logs/main.log",
    run:
        eq_classes = []
        groups = []
        names = []
        name_count = {}

        for path in Path(wildcards.path).glob("*/*_1.fastq.gz"):
            eq_classes.append(str(path.parent.joinpath("salmon", path.name[:-11] + "/aux_info/eq_classes.txt")))
            groups.append(path.parts[-2])

            if path.parts[-2] in name_count:
                name_count[path.parts[-2]] = name_count[path.parts[-2]] + 1
            else:
                name_count[path.parts[-2]] = 1
            
            names.append(path.parts[-2] + "_" + str(name_count[path.parts[-2]]))
        
        command = f"corset -g {','.join(groups)} -p {wildcards.path}/pooled/corset/output -f true -n {','.join(names)}" \
        f" -i salmon_eq_classes {' '.join(eq_classes)} 2> {log}"

        shell(command)
