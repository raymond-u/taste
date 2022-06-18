#!/usr/bin/env pypy3
# TODO: Port to Rust script.

import os
from enum import Enum, unique
from pathlib import Path

@unique
class Assembler(Enum):
    TRINITY = 1
    TRANSABYSS = 2
    SOAPDENOVOTRANS = 3
    OASES = 4

class Assembly_Merger:
    file_counter = 1

    def __init__(self, input, output, logger):
        self.input = input
        self.output = output
        self.logger = logger
    
    def _print_assemblies(self, files):
        for file in files:
            self.logger.write(f"({self.file_counter}) {file}\n")
            self.file_counter += 1
    
    def _parse_assemblies(self):
        assemblers = []

        if self.input.trinity:
            assemblers.append(Assembler.TRINITY)
            self.logger.write("Trinity assembly(ies):\n")
            self._print_assemblies(self.input.trinity)
        if self.input.transabyss:
            assemblers.append(Assembler.TRANSABYSS)
            self.logger.write("Trans-ABySS assembly(ies):\n")
            self._print_assemblies(self.input.transabyss)
        if self.input.soapdenovotrans:
            assemblers.append(Assembler.SOAPDENOVOTRANS)
            self.logger.write("SOAPdenovo-Trans assembly(ies):\n")
            self._print_assemblies(self.input.soapdenovotrans)
        if self.input.oases:
            assemblers.append(Assembler.OASES)
            self.logger.write("Oases assembly(ies):\n")
            self._print_assemblies(self.input.oases)
        
        return assemblers
    
    # TODO
    def _format_assemblies(self, assembler):
        if assembler is Assembler.TRINITY:
            for file in self.input.trinity:
                pass
        elif assembler is Assembler.TRANSABYSS:
            for file in self.input.transabyss:
                pass
        elif assembler is Assembler.SOAPDENOVOTRANS:
            for file in self.input.soapdenovotrans:
                pass
        elif assembler is Assembler.OASES:
            for file in self.input.oases:
                pass
    
    def merge(self):
        logger.write("------------------------------------------------------------\n")
        logger.write("Collecting assemblies.\n")
        assemblers = self._parse_assemblies()
        logger.write("Processing started...\n")
        
        for assembler in assemblers:
            self._format_assemblies(assembler)

os.makedirs(str(Path(snakemake.log[0]).parent), exist_ok=True)

with open(snakemake.log[0], "w") as logger:
    assembly_merger = Assembly_Merger(snakemake.input, snakemake.output[0], logger)
    assembly_merger.merge()
