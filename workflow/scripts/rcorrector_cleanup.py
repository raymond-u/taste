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
    
    logger.write(f"Input forward reads: {data['input'][0]}\n")
    logger.write(f"Input reverse reads: {data['input'][1]}\n")
    logger.write(f"Output forward reads: {data['output'][0]}\n")
    logger.write(f"Output reverse reads: {data['output'][1]}\n")
    logger.write(f"Total read pairs processed: {pair_total_count}\n")
    logger.write(f"Total read pairs corrected: {pair_corrected_count}\n")
    logger.write(f"Total read pairs removed: {pair_removed_count}\n")
