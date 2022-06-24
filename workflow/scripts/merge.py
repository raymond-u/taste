#!/usr/bin/env pypy3
# TODO: Port to Rust script.

import json
import sys
from enum import Enum, unique
from pathlib import Path

@unique
class Assembler(Enum):
    TRINITY = 1
    TRANSABYSS = 2
    SOAPDENOVOTRANS = 3
    OASES = 4

class Assembly_Merger:
    contig_counter = 0
    file_counter = 0
    
    def __init__(self, input, output, logger):
        self.input = input
        self.output = output
        self.logger = logger
    
    def _print_assemblies(self, files):
        for file in files:
            self.file_counter += 1
            self.logger.write(f"({self.file_counter}) {file}\n")
    
    def _parse_assemblies(self):
        assemblers = []
        
        if self.input["trinity"]:
            assemblers.append(Assembler.TRINITY)
            self.logger.write("Trinity assembly(ies):\n")
            self._print_assemblies(self.input.trinity)
        if self.input["transabyss"]:
            assemblers.append(Assembler.TRANSABYSS)
            self.logger.write("Trans-ABySS assembly(ies):\n")
            self._print_assemblies(self.input.transabyss)
        if self.input["soapdenovotrans"]:
            assemblers.append(Assembler.SOAPDENOVOTRANS)
            self.logger.write("SOAPdenovo-Trans assembly(ies):\n")
            self._print_assemblies(self.input.soapdenovotrans)
        if self.input["oases"]:
            assemblers.append(Assembler.OASES)
            self.logger.write("Oases assembly(ies):\n")
            self._print_assemblies(self.input.oases)
        
        return assemblers
    
    def _format_assemblies(self, assembler):
        for file in self.input[assembler.name.lower()]:
            with open(file, "r") as input:
                assembly_name = f"{assembler.name.lower()}|{Path(file).stem.split('_')[-1]}"
                header = ""
                
                while True:
                    line = input.readline()
                    
                    if line == "":
                        break
                    elif line.startswith(">"):
                        header = line
                    else:
                        # do this to strip header line with no sequence
                        if header != "":
                            self.contig_counter += 1
                            self.output.write(f">no|{self.contig_counter}|{assembly_name}|{header.lstrip('>')}")
                            header = ""
                        
                        self.output.write(line)
    
    def merge(self):
        logger.write("------------------------------------------------------------\n")
        logger.write("Collecting assemblies.\n")
        assemblers = self._parse_assemblies()
        logger.write("Processing started...\n")
        
        for assembler in assemblers:
            self._format_assemblies(assembler)

data = json.loads(sys.argv[1])

with open(data["output"], "w") as output, open(data["log"], "w") as logger:
    assembly_merger = Assembly_Merger(data["input"], output, logger)
    assembly_merger.merge()
