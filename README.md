# About

Pipeline gets assembly in fasta format, and reads in fq format as default (see `Required settings` section below).
As an output it generates hetero/homozygosity plots, coverage plots considering PAR (Pseudoautosomal regions).

All general results you can find in `data_output` folder.

All additional information can also be found in `readme` files incide required directories.

# Configure Pipeline

`cd <pipeline_working_dir>`

`git clone https://github.com/BioHappyThreeFriends/varcaller.git`

`cd varcaller`

It is recommended to create a fresh conda environment using `mamba` or `conda`.

```
mamba env create --name varcaller --file ./environment.yaml
# or:
# conda env create --name varcaller --file ./environment.yaml
```

Activate conda environment with snakemake:

`conda activate varcaller`

# Run

`snakemake --cores 32 --configfile config/config.yaml --forceall --use-conda --profile profile/slurm/ --printshellcmds --latency-wait 60`

![rulegraph](https://user-images.githubusercontent.com/34814028/162024882-41ea8e19-03b1-4ab7-9a90-e8afb91fcd38.png)
