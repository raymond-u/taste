wildcard_constraints:
    run_number="[^/]+"

rule template:
    input:
        ""
    output:
        ""
    log:
        ""
    params:
        ""
    threads:
        8
    conda:
        "../../envs/.yaml"
    shadow:
        "minimal"
    shell:
        ""
