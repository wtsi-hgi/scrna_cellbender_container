#### scrna_cellbender_container

- Dockerhub auto-build:  
    see https://hub.docker.com/repository/docker/wtsihgi/nf_cellbender

##### current software versions:  
the versions are saved during docker build in container file `/usr/conda_software_versions.txt`:  
```
docker run wtsihgi/nf_cellbender:v1.3 cat /usr/conda_software_versions.txt
singularity exec --containall docker://wtsihgi/nf_cellbender:v1.3 cat /usr/conda_software_versions.txt
```

- Convert docker image to singularity:

```
singularity pull docker://wtsihgi/nf_cellbender:v1.3

## option 1 (pull first):
# check conda env is loaded by default (requires --containall):
singularity pull docker://wtsihgi/nf_cellbender:v1.3
singularity exec --containall nf_cellbender_v1.3.sif conda env list
singularity exec --containall nf_cellbender:v1.3 cellbender --help

## option 2 (single command, exec directly from Dockerhub):
singularity exec --containall docker://wtsihgi/nf_cellbender:v1.3 conda env list
singularity exec --containall docker://wtsihgi/nf_cellbender:v1.3 cellbender --help

## option 3 (user Docker to create singularity image):
export IMAGE=wtsihgi/nf_cellbender:v1.3
mkdir -p ~/singu &&  rm -rf singu/*.sif
docker run -v /var/run/docker.sock:/var/run/docker.sock -v ~/singu:/output --privileged -t --rm quay.io/singularity/docker2singularity $IMAGE
# check image:
singularity shell --containall singu/wtsihgi_nf_cellbender-*.sif  conda env list
```

