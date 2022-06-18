import json

def get_upper_floor(number):
    if number % 10 == 0:
        return number
    
    return (number // 10 + 1) * 10

def estimate_insert_size(forward_read_length, reverse_read_length):
    return forward_read_length + reverse_read_length + 50

def get_insert_size(files):
    insert_sizes = []

    for file in files:
        with open(file, "r") as f:
            report = json.load(f)
            peak = report["insert_size"]["peak"]

            if peak == 0:
                insert_sizes.append(estimate_insert_size(get_upper_floor(report["summary"]["before_filtering"]["read1_mean_length"]),
                get_upper_floor(report["summary"]["before_filtering"]["read2_mean_length"])))
            else:
                unknown = report["insert_size"]["unknown"]
                histogram = report["insert_size"]["histogram"]

                if unknown / (unknown + sum(histogram)) > 0.5:
                    insert_sizes.append(estimate_insert_size(get_upper_floor(report["summary"]["before_filtering"]["read1_mean_length"]),
                    get_upper_floor(report["summary"]["before_filtering"]["read2_mean_length"])))
                else:
                    insert_sizes.append(peak)
    
    return round(sum(insert_sizes) / len(insert_sizes))

def get_max_read_length(files):
    max_read_length = 0

    for file in files:
        with open(file, "r") as f:
            report = json.load(f)
            read_length = max(get_upper_floor(report["summary"]["before_filtering"]["read1_mean_length"]),
            get_upper_floor(report["summary"]["before_filtering"]["read2_mean_length"]))

            if read_length > max_read_length:
                max_read_length = read_length
    
    return max_read_length

with open(snakemake.output[0], "w") as config:
    config.write("# maximal read length\n")
    config.write(f"max_rd_len={get_max_read_length(snakemake.input.reports)}\n")
    config.write("[LIB]\n")
    config.write("# average insert size\n")
    config.write(f"avg_ins={get_insert_size(snakemake.input.reports)}\n")
    config.write("# in which part(s) the reads are used\n")
    config.write("asm_flags=3\n")
    config.write("# fastq file for forward reads\n")
    config.write(f"q1={snakemake.input.reads[0]}\n")
    config.write("# fastq file for reverse reads (always follows q1)\n")
    config.write(f"q2={snakemake.input.reads[1]}\n")
