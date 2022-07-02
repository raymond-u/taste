//! ```cargo
//! [dependencies]
//! bio = "*"
//! flate2 = { version = "*", features = ["zlib-ng-compat"], default-features = false }
//! ```

use anyhow::Result;
use bio::io::fastq;
use flate2::Compression;
use flate2::read::MultiGzDecoder;
use flate2::write::GzEncoder;
use std::fs::File;
use std::io::{BufReader, Write};
use std::path::Path;

const CORRECTED_STRING: &str = "cor";
const METRIC_STRING: &str  = " l:";
const UNFIXABLE_STRING: &str = "unfixable_error";

fn get_fastq_reader<P: AsRef<Path>>(path: P) -> Result<fastq::Reader<BufReader<MultiGzDecoder<File>>>> {
    let file = File::open(path)?;
    Ok(fastq::Reader::new(MultiGzDecoder::new(file)))
}

fn get_fastq_writer<P: AsRef<Path>>(path: P) -> Result<fastq::Writer<GzEncoder<File>>> {
    let file = File::create(path)?;
    Ok(fastq::Writer::new(GzEncoder::new(file, Compression::fast())))
}

fn get_logger<P: AsRef<Path>>(path: P) -> Result<File> {
    let file = File::create(path)?;
    Ok(file)
}

fn main() -> Result<()> {
    let mut forward_records = get_fastq_reader(snakemake.input[0])?.records();
    let mut reverse_records = get_fastq_reader(snakemake.input[1])?.records();
    let mut output_forward = get_fastq_writer(snakemake.output[0])?;
    let mut output_reverse = get_fastq_writer(snakemake.output[1])?;
    let mut logger = get_logger(snakemake.log[0])?;
    
    let mut total_count = 0;
    let mut corrected_count = 0;
    let mut removed_count = 0;
    
    while let (Some(forward_record), Some(reverse_record)) = (forward_records.next(), reverse_records.next()) {
        let forward_record = forward_record?;
        let reverse_record = reverse_record?;
        
        total_count += 1;
        
        if forward_record.desc().unwrap().ends_with(UNFIXABLE_STRING) || reverse_record.desc().unwrap().ends_with(UNFIXABLE_STRING) {
            removed_count += 1;
            continue;
        }
        
        if forward_record.desc().unwrap().ends_with(CORRECTED_STRING) || reverse_record.desc().unwrap().ends_with(CORRECTED_STRING) {
            corrected_count += 1;
        }
        
        let mut forward_header = String::from(forward_record.id());
        forward_header.push(' ');
        forward_header.push_str(forward_record.desc().unwrap());
        
        let forward_header = forward_header.rsplit_once(METRIC_STRING).unwrap().0;
        
        let mut reverse_header = String::from(reverse_record.id());
        reverse_header.push(' ');
        reverse_header.push_str(reverse_record.desc().unwrap());
        
        let reverse_header = reverse_header.rsplit_once(METRIC_STRING).unwrap().0;
        
        output_forward.write(forward_header, None, forward_record.seq(), forward_record.qual())?;
        output_reverse.write(reverse_header, None, reverse_record.seq(), reverse_record.qual())?;
    }
    
    writeln!(logger, "Input forward reads: {}", snakemake.input[0])?;
    writeln!(logger, "Input reverse reads: {}", snakemake.input[1])?;
    writeln!(logger, "Output forward reads: {}", snakemake.output[0])?;
    writeln!(logger, "Output reverse reads: {}", snakemake.output[1])?;
    writeln!(logger, "Total read pairs processed: {}", total_count)?;
    writeln!(logger, "Total read pairs corrected: {}", corrected_count)?;
    writeln!(logger, "Total read pairs removed: {}", removed_count)?;
    
    output_forward.flush()?;
    output_reverse.flush()?;
    logger.flush()?;
    
    Ok(())
}
