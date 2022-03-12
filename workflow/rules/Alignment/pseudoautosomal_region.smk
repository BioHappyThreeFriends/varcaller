rule pseudoautosomal_region:
    input:
        whole_stats=rules.coverage_whole_genome_stats.output, 
        window_stats=alignment_dir_path / ("{sample}/{assembly}.{sample}.coverage_{par_size}_windows_stats.csv")
    output:
        bed=alignment_dir_path / "{sample}/PAR/{assembly}.{sample}.{par_size}_pseudoreg.bed",
        chrscaf=temp(alignment_dir_path / "{sample}/PAR/{assembly}.{sample}.{par_size}_chrscaf.csv")
    params:
        outdir=lambda w: alignment_dir_path / ("{sample}/PAR").format(sample=w.sample),
        prefix=lambda w: alignment_dir_path / ("{sample}/PAR/{assembly}.{sample}.{par_size}").format(assembly=w.assembly, sample=w.sample, par_size=PAR_SIZE),
        scaffold_name=config["sex_scaffold_name"],
        par_window_size=PAR_SIZE
    log:
        std=log_dir_path / "{sample}/{assembly}.{sample}.{par_size}.pseudoautosomal_region.log",
        cluster_log=cluster_log_dir_path / "{sample}/{assembly}.{sample}.{par_size}.pseudoautosomal_region.cluster.log",
        cluster_err=cluster_log_dir_path / "{sample}/{assembly}.{sample}.{par_size}.pseudoautosomal_region.cluster.err"
    benchmark:
         benchmark_dir_path / "{sample}/{assembly}.{sample}.{par_size}.pseudoautosomal_region.benchmark.txt"
    conda:
        "../../../%s" % config["conda_config"]
    resources:
        cpus=config["pseudoautosomal_region_threads"],
        time=config["pseudoautosomal_region_time"],
        mem=config["pseudoautosomal_region_mem_mb"]
    threads:
        config["pseudoautosomal_region_threads"]
    shell:
        "mkdir -p {params.outdir}; "
        "cat {input.window_stats} | awk '{{ if ($1 == \"'{params.scaffold_name}'\") print $0}}' > {output.chrscaf}; "
        "pseudoautosomal_region.py -f {params.par_window_size} -i {output.chrscaf} "
        "-s {params.scaffold_name} -o {params.prefix} "
        "-m $(cat {input.whole_stats} | sed -n 2p | awk '{{print $2}}') > {log.std} 2>&1 "


rule ploidy_file:
    input:
        beds=expand(alignment_dir_path / "{sample}/PAR/{assembly}.{sample}.{par_size}_pseudoreg.bed", assembly=ASSEMBLY, sample=SAMPLES[SAMPLES["sex"]=='M'].sample_id, par_size=PAR_SIZE),
        lenfile=assembly_stats_dir_path / "{assembly}.len"
    output:
        assembly_stats_dir_path / "{assembly}.ploidy.file"
    log:
        std=log_dir_path / "{assembly}.ploidy_file.log",
        cluster_log=cluster_log_dir_path / "{assembly}.ploidy_file.cluster.log",
        cluster_err=cluster_log_dir_path / "{assembly}.ploidy_file.cluster.err"
    benchmark:
         benchmark_dir_path / "{assembly}.ploidy_file.benchmark.txt"
    conda:
        "../../../%s" % config["conda_config"]
    resources:
        cpus=config["pseudoautosomal_region_threads"],
        time=config["pseudoautosomal_region_time"],
        mem=config["pseudoautosomal_region_mem_mb"]
    threads:
        config["pseudoautosomal_region_threads"]
    shell:
        "workflow/scripts/ploidy_file_generator.py --input {input.beds} --lenfile {input.lenfile} -o {output} > {log.std} 2>&1"


rule samples_file:
    input:
        config["samples"] # samples.tsv file
    output:
        assembly_stats_dir_path / "{assembly}.samples.file"
    log:
        std=log_dir_path / "{assembly}.samples_file.log",
        cluster_log=cluster_log_dir_path / "{assembly}.samples_file.cluster.log",
        cluster_err=cluster_log_dir_path / "{assembly}.samples_file.cluster.err"
    benchmark:
         benchmark_dir_path / "{assembly}.samples_file.benchmark.txt"
    conda:
        "../../../%s" % config["conda_config"]
    resources:
        cpus=config["pseudoautosomal_region_threads"],
        time=config["pseudoautosomal_region_time"],
        mem=config["pseudoautosomal_region_mem_mb"]
    threads:
        config["pseudoautosomal_region_threads"]
    shell:
        "tail -n+2 {input} | awk '{{print $1\"\t\"$2}}' > {output} 2> {log.std} "