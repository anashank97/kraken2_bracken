# kraken2_bracken

This script helps automate the workflow for generating taxonomy classifications using kraken2-bracken using different parameter settings.

The script automatically loops through the FASTQ file pairs in the input directory ands runs kraken2 and bracken sequentially. Parameters can be modified in the script as needed.

These results can be analyzed downstream using the python Jupyter notebook. An example notebook (bracken.ipynb) to compare kraken2 and metaphlan results is also included in the repository.
