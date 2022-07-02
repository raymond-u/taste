//! ```cargo
//! [dependencies]
//! bio = "*"
//! ```

use anyhow::Result;
use bio::io::fasta;
use std::fs::File;
use std::io::{BufReader, Write};
use std::path::Path;

fn get_fasta_reader<P: AsRef<Path>>(path: P) -> Result<fasta::Reader<BufReader<File>>> {
    let file = File::open(path)?;
    Ok(fasta::Reader::new(file))
}

fn get_fasta_writer<P: AsRef<Path>>(path: P) -> Result<fasta::Writer<File>> {
    let file = File::create(path)?;
    Ok(fasta::Writer::new(file))
}

fn get_logger<P: AsRef<Path>>(path: P) -> Result<File> {
    let file = File::create(path)?;
    Ok(file)
}

fn main() -> Result<()> {
    let mut output = get_fasta_writer(snakemake.output[0])?;
    let mut logger = get_logger(snakemake.log[0])?;
    
    let mut file_count = 0;
    let mut contig_count = 0;
    let mut previous_count = 0;
    
    macro_rules! merge_assembly {
        ($code_name:ident, $long_name:literal) => {
            if !snakemake.input.$code_name.is_empty() {
                writeln!(logger, "==================== {} assembly(ies) ====================", $long_name)?;
                
                for path in snakemake.input.$code_name {
                    for record in get_fasta_reader(path)?.records() {
                        let record = record?;
                        
                        if record.seq().is_empty() {
                            continue;
                        }
                        
                        contig_count += 1;
                        
                        let kmer = path.rsplit_once('_').unwrap().1.split_once('.').unwrap().0;
                        
                        let mut header = String::from(record.id());
                        
                        if let Some(desc) = record.desc() {
                            header.push(' ');
                            header.push_str(desc);
                        }
                        
                        let header = format!("no|{}|{}|{}|{}", contig_count, $long_name, kmer, header);
                        
                        output.write(&header, None, record.seq())?;
                    }
                    
                    file_count += 1;
                    
                    writeln!(logger, "{}. {} contigs read from {}", file_count, contig_count - previous_count, path)?;
                    
                    previous_count = contig_count;
                }
                
                writeln!(logger)?;
            }
        };
    }
    
    merge_assembly!(trinity, "Trinity");
    merge_assembly!(transabyss, "Trans-ABySS");
    merge_assembly!(soapdenovotrans, "SOAPdenovo-Trans");
    merge_assembly!(oases, "Oases");
    
    writeln!(logger, "==================== Output ====================")?;
    writeln!(logger, "{} contigs merged to {}", contig_count, snakemake.output[0])?;
    
    Ok(())
}
