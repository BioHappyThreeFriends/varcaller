# About

Pipeline gets assembly in fasta format, and reads in fq format as default (see `Required settings` section below). 
As an output it generates ... (pipeline is in progress).

All general results you can find in `data_output` folder.

# Configure Pipeline

`git clone https://github.com/rutaolta/reseqpipe.git`

`cd <pipeline_working_dir>`

It is recommended to create a fresh conda environment using `mamba` or `conda`.

```
mamba env create --name reseqpipe --file ./environment.yaml
# or:
# conda env create --name reseqpipe --file ./environment.yaml
```

Activate conda environment with snakemake:

`conda activate reseqpipe`

# Run

`snakemake --cores 32 --configfile config/default.yaml --forceall --use-conda --profile profile/slurm/ --printshellcmds --latency-wait 60`

# Required settings

Extensions of assembly and reads can be changed in `config/default.yaml` in "Extensions" section:

    - `assemblies_ext: "your desired extension"`
    
    - `reads_ext: "your desired extension"`

The name of file with reference assembly should be defined in `config/default.yaml` in "Parameters" section:

    - `reads: ["name of your desired reads"]`

Actually this is the common part of filenames containing forward and reverse reads. Filename should be without extensions. For example, if desired reads are `cerevisiae_1.fq.gz` and `cerevisiae_2.fq.gz` then the setting would be like `reads: ["cerevisiae"]`.

Suffix of filename with foward read should be "_1" and with reverse "_2". For example, `cerevisiae_1.fq.gz`

    - `assembly: ["name of your desired assembly"]`

Actually this is the name of files containing assembly. Filename should be without extensions. For example, if desired assembly is `s.cerevisiae.fasta.gz` then the setting would be like `assembly: "s.cerevisiae"`.

The mapping quality for mosdepth can be changed in `config/default.yaml` in "Parameters" section:

    - `min_mapping_quality: your_desired_quality_integer` (20 as default)
