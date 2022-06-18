#!/usr/bin/env python3

import json
import os

def prepare_download(trans, path_str, bash=""):

    if len(trans["children"]) == 0:
        os.makedirs(path_str, exist_ok=True)

        if trans["rank"] == "species":
            for run in trans["transcriptomes"]:
                os.makedirs(os.path.join(path_str, "transcriptomes", run["tissue"]), exist_ok=True)

                strand = []

                if not os.path.exists(os.path.join(path_str, "transcriptomes", run["tissue"], run["run"] + "_1.fastq.gz")):
                    strand.append(1)
                if not os.path.exists(os.path.join(path_str, "transcriptomes", run["tissue"], run["run"] + "_2.fastq.gz")):
                    strand.append(2)

                bash += generate_download_command(run["run"], os.path.join(path_str, "transcriptomes", run["tissue"]), strand) + "\n"

    for child in trans["children"]:
        bash = prepare_download(child, os.path.join(path_str, child["name"]), bash)

    return bash

def generate_download_command(accession_number, path_str, strand):
    if accession_number[1:3] == ("RR") and accession_number[3:].isdecimal():
        return "\n".join(["ascp -QT -k 2 -l 300m -P33001 -i $HOME/.aspera/connect/etc/asperaweb_id_dsa.openssh era-fasp@fasp.sra.ebi.ac.uk:vol1/fastq/"
        f"{accession_number[:6]}/{f'{int(accession_number[9 - len(accession_number):]):03d}/' if len(accession_number) > 9 else ''}{accession_number}/{accession_number}_{i}.fastq.gz {path_str}" for i in strand])
    else:
        print(f"{accession_number}: format not recognized. Skipping.")

        return ""

def download_user_data(trans):
    bash = prepare_download(trans, trans["name"])

    try:
        with open("download_user_data.sh", "w") as file:
            file.write("\n".join([i for i in bash.split("\n") if i]))
    except Exception as err:
        print(err)
    
    print("Running download_user_data.sh in background.")
    os.system("nohup bash download_user_data.sh &")

if __name__ == "__main__":
    try:
        with open("user_data.json", "r") as file:
            user_data = json.load(file)
    except Exception as err:
        print(err)
    
    download_user_data(user_data)
