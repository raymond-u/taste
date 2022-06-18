#!/usr/bin/env pypy3
# TODO: Port to Rust script.

import json
import gzip
import sys

append_string = " l:"
corrected_string = " cor\n"
unfixed_string = " unfixable_error\n"

data = json.loads(sys.argv[1])

with gzip.open(data["output"][0], "wt") as fwd_pooled, gzip.open(data["output"][1], "wt") as rev_pooled, open(data["log"], "w") as logger:

    with gzip.open(data["input"][0], "rt") as fwd_reads, gzip.open(data["input"][1], "rt") as rev_reads:
        logger.write("------------------------------------------------------------\n")
        logger.write(f"Forward reads: {data['input'][0]}.\n")
        logger.write(f"Reverse reads: {data['input'][1]}.\n")
        logger.write("Processing started...\n")

        pair_total_count = 0
        pair_corrected_count = 0
        pair_removed_count = 0

        while True:
            fwd_read = fwd_reads.readline()
            rev_read = rev_reads.readline()
            
            if fwd_read == "" or rev_read == "":
                break
            
            pair_total_count += 1
            
            if fwd_read.endswith(unfixed_string) or rev_read.endswith(unfixed_string):
                pair_removed_count += 1

                fwd_reads.readline()
                fwd_reads.readline()
                fwd_reads.readline()
                rev_reads.readline()
                rev_reads.readline()
                rev_reads.readline()
                
                continue
            else:
                if fwd_read.endswith(corrected_string) or rev_read.endswith(corrected_string):
                    pair_corrected_count += 1
                
                fwd_pooled.write(fwd_read[:fwd_read.rfind(append_string)] + "\n")
                rev_pooled.write(rev_read[:fwd_read.rfind(append_string)] + "\n")

                fwd_pooled.write(fwd_reads.readline())
                fwd_pooled.write(fwd_reads.readline())
                fwd_pooled.write(fwd_reads.readline())
                rev_pooled.write(rev_reads.readline())              
                rev_pooled.write(rev_reads.readline())
                rev_pooled.write(rev_reads.readline())
        
        logger.write(f"{pair_total_count} read pairs were processed in total.\n")
        logger.write(f"{pair_corrected_count} read pairs were repaired by Rcorrector.\n")
        logger.write(f"{pair_removed_count} read pairs tagged as unfixable were removed.\n")
        logger.write(f"Forward reads saved to {data['output'][0]}.\n")
        logger.write(f"Reverse reads saved to {data['output'][1]}.\n")
        logger.write("Processing ended.\n")
        logger.write("------------------------------------------------------------\n")
