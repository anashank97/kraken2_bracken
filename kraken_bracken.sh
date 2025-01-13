#!/bin/bash

# Set default parameters for Kraken2
INPUT_DIR='/DCEG/Projects/Microbiome/Metagenomics/Project_CGRSA1321/RAW'  # Directory containing your FASTQ files
OUTPUT_DIR='/DCEG/CGF/Bioinformatics/Production/Anand/kraken2/output_all'           # Directory to save Kraken2 output
KRAKEN2_DB='/DCEG/Projects/Microbiome/Metagenomics/Kraken/kraken2/kraken2_chocophlanV30-201901'  # Kraken2 DB path
THREADS=16                            # Number of threads for Kraken2

# Loop through all *_R1_001.fastq.gz files in the input directory
for f1 in "$INPUT_DIR"/*_R1_001.fastq.gz; do
    # Check if the corresponding *_R2_001.fastq.gz file exists
    f2="${f1/_R1_001.fastq.gz/_R2_001.fastq.gz}"
    
    if [[ -f "$f2" ]]; then
        # Get the base name of the files (without path and extension)
        base_name=$(basename "$f1" "_R1_001.fastq.gz")
        
        # Output files for Kraken2
        report_file="$OUTPUT_DIR/${base_name}.k2report"
        kraken_output_file="$OUTPUT_DIR/${base_name}.kraken2"
        
        # Run Kraken2 with the specified parameters
        echo "Running Kraken2 for $f1 and $f2 ..."
        kraken2 --threads $THREADS \
                --db "$KRAKEN2_DB" \
		--confidence 0.1 \
                --report "$report_file" \
                --report-minimizer-data \
                --gzip-compressed \
                --paired "$f1" "$f2" \
                > "$kraken_output_file"
        
        # Check if Kraken2 ran successfully
        if [[ $? -eq 0 ]]; then
            echo "Successfully completed Kraken2 for $f1 and $f2"
        else
            echo "Error running Kraken2 for $f1 and $f2"
        fi

        bracken_output_file="$OUTPUT_DIR/${base_name}.bracken"
        bracken_report_file="$OUTPUT_DIR/${base_name}.breport"
        
        echo "Running Bracken for $base_name ..."
        bracken -d "$KRAKEN2_DB" \
                -i "$report_file" \
                -o "$bracken_output_file" \
                -w "$bracken_report_file" \
                -l S
        
        # Check if Bracken ran successfully
        if [[ $? -eq 0 ]]; then
            echo "Successfully completed Bracken for $base_name"
        else
            echo "Error running Bracken for $base_name"
        fi
    else
        echo "Warning: Paired file for $f1 not found: $f2"
    fi
done

echo "Kraken2 processing complete."

