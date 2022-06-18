# TASTES

Just another de-novo transcriptome assembly & annotation toolkit written in Snakemake.

## Features

This is a working-in-progress project and is NOT ready for production use!

TASTES is a general-purpose de-novo transcriptome assembly & annotation toolkit powered by Snakemake.

TASTES is designed to work on hundreds of RNA-seq datasets of different species simultaneously, although it is possible to work on a selected few. Raw reads are first fed to the preprocessing module, with QC reports generated before and after the preprocessing. Then they go through de-novo assembly using a multi-assembler & kmer approach. Assemblies are later merged with efforts to minimize loss of paralogs. Lastly, the transcripts are annotated, and a completeness report is generated. Modules are meant to be switchable and customizable whenever possible.

- Bundled with a script that automates downloading and organizing RNA-seq datasets from the NCBI SRA database.
- Designed with flexibility and customizability in mind.
- Can be easily extended and scaled up, thanks to Snakemake.

## Pipeline Overview

![TASTES](https://user-images.githubusercontent.com/36328498/174443998-3700e1ba-4e7b-49cc-b6ef-c8996d3b4055.png)

## Installing

Get TASTES by issuing:
```bash
$ git clone https://github.com/raymond-u/tastes.git
```

TASTES depends on a number of projects.
Please refer to respective instructions on how to install them. This list is subject to change.
- [Snakemake](https://github.com/snakemake/snakemake)
- [FastQC](https://github.com/s-andrews/FastQC)
- [fastp](https://github.com/OpenGene/fastp)
- [Rcorrector](https://github.com/mourisl/Rcorrector)
- [SortMeRNA](https://github.com/biocore/sortmerna)
- [ORNA](https://github.com/SchulzLab/ORNA)
- [Trinity](https://github.com/trinityrnaseq/trinityrnaseq)
- [Trans-ABySS](https://github.com/bcgsc/transabyss)
- [SOAPdenovo-Trans](https://github.com/aquaskyline/SOAPdenovo-Trans)
- [Oases](https://github.com/dzerbino/oases)
- [Evigene/tr2aacds.pl](http://arthropods.eugenes.org/EvidentialGene/evigene/scripts/prot/tr2aacds.pl)
- [MCSC Decontamination](https://github.com/Lafond-LapalmeJ/MCSC_Decontamination)
- [TransRate](https://github.com/pmomadeira/transrate)
- [BUSCO](https://gitlab.com/ezlab/busco)
- [dammit](https://github.com/dib-lab/dammit)

Make sure they can be found in $PATH, or paths to their executables are properly configured in `config/config.yaml`.

## Usage

The main pipeline of TASTES is designed to work on data structured as below:

```
data
│
+───subfamily A
│   │
│   +───genus a
│       │
│       +───species 0
│       │   │
│       │   +───root
│       │   │   │   SRRxxxxxxxx_1.fasta.gz
│       │   │   │   SRRxxxxxxxx_2.fasta.gz
│       │   │   │   SRRyyyyyyyy_1.fasta.gz   # replication of the same tissue
│       │   │   │   SRRyyyyyyyy_2.fasta.gz
│       │   │
│       │   +───leaf
│       │       │   ...
│       │
│       +───species 1
│           │
│           +───...
│   
+───subfamily B
    │
    +───...
```

The script located at `data/download_user_data.py` can automatically download and maintain such structure, as per the config file `data/user_data.json`. If you already have some data, it might be necessary to re-organize them.

Before calling the main pipeline, do edit `config/config.yaml` to instruct TASTES on how to locate specific executables and fit your use case.

To perform a dry-run, simply issue:
```bash
$ cd TASTES
$ snakemake -n -r
```

To run to finish, issue:
```bash
$ cd TASTES
$ snakemake --cores 8 # tell Snakemake to use up to 8 cores
```

Since it takes quite some time to complete, it is advisable to set up a monitoring server (also see [Snakemake docs](https://snakemake.readthedocs.io/en/stable/executing/monitoring.html)):
```bash
$ cd TASTES
$ pip install panoptes-ui
$ nohup panoptes &
snakemake --cores 8 --wms-monitor http://127.0.0.1:5000
```

## TODO

- Finish the main pipeline (yup, have fun playing around and breaking things).
- Make modules optional whenever possible.
- Add unit tests.
- Add comprehensive docs.
- Support single-end and long-read data.
- Make use of Snakemake wrappers and Conda environment definition.
- Make TASTES more accessible by simplifying installing.
- A logo with TASTES!

## Disclaimer

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

## License

MIT license.
