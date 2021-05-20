FROM continuumio/miniconda3
# ARG conda_env variable must match conda env name in environment.yml:
ARG conda_env=conda_cellbender

LABEL authors="Guillaume Noell" \
  maintainer="Guillaume Noell <gn5@sanger.ak>" \
  description="Docker image for WSTI-HGI scRNA cellbender pipeline"

# nuke cache dirs before installing pkgs; tip from Dirk E fixes broken img
RUN rm -f /var/lib/dpkg/available && rm -rf  /var/cache/apt/*
RUN apt-get update && \
  apt-get -y upgrade && \
  apt-get install -y --no-install-recommends \
  build-essential \
  curl \
  git \
  libbz2-dev \
  python-pip \
  zlib1g-dev \
  procps \ 
  && rm -rf /var/lib/apt/lists/*

# install Conda env:
ADD environment.yml /tmp/environment.yml
RUN conda env create -f /tmp/environment.yml

# Set installed Conda env as default:
ENV CONDA_DEFAULT_ENV $conda_env
ENV PATH /opt/conda/envs/$conda_env/bin:$PATH
RUN echo $PATH

# Add additional software using Conda env:
RUN /bin/bash -c "source activate $conda_env \
    && pip install cellSNP \
    && pip install vireoSNP \
    && conda env list"
    
# test main python libraries can be loaded:
RUN python -c 'import sys;print(sys.version_info);import cellSNP; import vireoSNP; import scanpy; import click; import pandas; import plotnine; import matplotlib'

## check software versions:
RUN cellSNP  >> /usr/conda_software_versions.txt 2>&1 || true
RUN cellsnp-lite -V >> /usr/conda_software_versions.txt 2>&1 || true
RUN vireo  >> /usr/conda_software_versions.txt 2>&1 || true
RUN which python >> /usr/conda_software_versions.txt
RUN python --version >> /usr/conda_software_versions.txt
RUN tabix --version  >> /usr/conda_software_versions.txt
RUN bcftools --version  >> /usr/conda_software_versions.txt
RUN samtools --version  >> /usr/conda_software_versions.txt
RUN cat /usr/conda_software_versions.txt

CMD /bin/sh
