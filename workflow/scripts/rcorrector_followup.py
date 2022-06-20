#!/usr/bin/env pypy3
# TODO: Port to Rust script.

import json
import gzip
import sys
from contextlib import ExitStack

metric_string = " l:"
corrected_string = " cor\n"
unfixed_string = " unfixable_error\n"

data = json.loads(sys.argv[1])

with ExitStack() as stack:
    fwd_input = stack.enter_context(gzip.open(data["input"][0], "rt"))
    rev_input = stack.enter_context(gzip.open(data["input"][1], "rt"))
    fwd_output = stack.enter_context(gzip.open(data["output"][0], "wt"))
    rev_output = stack.enter_context(gzip.open(data["output"][1], "wt"))
    logger = stack.enter_context(open(data["log"], "w"))
    
    logger.write("------------------------------------------------------------\n")
    logger.write(f"Forward reads: {data['input'][0]}.\n")
    logger.write(f"Reverse reads: {data['input'][1]}.\n")
    logger.write("Processing started...\n")
    
    pair_total_count = 0
    pair_corrected_count = 0
    pair_removed_count = 0
    
    while True:
        fwd_read = fwd_input.readline()
        rev_read = rev_input.readline()
        
        if fwd_read == "" or rev_read == "":
            break
        
        pair_total_count += 1
        
        if fwd_read.endswith(unfixed_string) or rev_read.endswith(unfixed_string):
            pair_removed_count += 1
            
            fwd_input.readline()
            fwd_input.readline()
            fwd_input.readline()
            rev_input.readline()
            rev_input.readline()
            rev_input.readline()
            
            continue
        
        if fwd_read.endswith(corrected_string) or rev_read.endswith(corrected_string):
            pair_corrected_count += 1
        
        fwd_output.write(fwd_read[:fwd_read.rfind(metric_string)] + "\n")
        rev_output.write(rev_read[:fwd_read.rfind(metric_string)] + "\n")
        
        fwd_output.write(fwd_input.readline())
        fwd_output.write(fwd_input.readline())
        fwd_output.write(fwd_input.readline())
        rev_output.write(rev_input.readline())              
        rev_output.write(rev_input.readline())
        rev_output.write(rev_input.readline())
    
    logger.write(f"{pair_total_count} read pairs were processed in total.\n")
    logger.write(f"{pair_corrected_count} read pairs were repaired by Rcorrector.\n")
    logger.write(f"{pair_removed_count} read pairs tagged as unfixable were removed.\n")
    logger.write(f"Forward reads saved to {data['output'][0]}.\n")
    logger.write(f"Reverse reads saved to {data['output'][1]}.\n")
    logger.write("Processing ended.\n")
    logger.write("------------------------------------------------------------\n")
