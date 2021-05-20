#!/usr/bin/env bash
# this script is placed/run at /lustre/scratch123/hgi/projects/ukbb_scrna/pipelines/singularity_images/ 

# choose dockerhub image tag
# cf. https://github.com/wtsi-hgi/nf_cellbender_container
tag=v1.1

mkdir -p cache_dir
export SINGULARITY_CACHEDIR=$PWD/cache_dir

mkdir -p tmp_dir
export TMPDIR=$PWD/tmp_dir

rm -f nf_cellbender${tag}.sif || true
rm -f nf_cellbender${tag}.img || true

singularity pull docker://wtsihgi/nf_cellbender:${tag}
mv nf_cellbender${tag}.sif nf_cellbender${tag}.img
