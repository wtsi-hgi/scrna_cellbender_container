#### scrna_cellbender_container

- Dockerhub auto-build:  
    see https://hub.docker.com/repository/docker/wtsihgi/nf_cellbender

##### current software versions:  
the versions are saved during docker build in container file `/usr/conda_software_versions.txt`:  
(`docker run wtsihgi/scrna_cellbender_container:1.0 cat /usr/conda_software_versions.txt`)

github/dockerhub tag **1.1** has:
```
cellbender built from git commit 78f005fc8dc9313328d4ef7a6f4ed985fa253187 Add support for AnnData inputs (#90)
# (from git clone https://github.com/broadinstitute/CellBender.git && pip install -e CellBender)
```

- Convert docker image to singularity:

```
singularity pull docker://wtsihgi/scrna_cellbender:1.1

## option 1 (pull first):
# check conda env is loaded by default (requires --containall):
singularity exec --containall scrna_cellbender_1.1.sif conda env list

## option 2 (single command, exec directly from Dockerhub):
singularity exec --containall docker://wtsihgi/scrna_cellbender:1.1 conda env list

## option 3 (user Docker to create singularity image):
export IMAGE=wtsihgi/scrna_cellbender:1.1
mkdir -p ~/singu &&  rm -rf singu/*.sif
docker run -v /var/run/docker.sock:/var/run/docker.sock -v ~/singu:/output --privileged -t --rm quay.io/singularity/docker2singularity $IMAGE
# check image:
singularity shell --containall singu/wtsihgi_scrna_cellbender-*.sif  conda env list
```

