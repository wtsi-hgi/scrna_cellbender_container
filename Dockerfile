FROM continuumio/miniconda3
# ARG conda_env variable must match conda env name in environment.yml:
ARG conda_env=conda_cellbender

LABEL authors="Guillaume Noell" \
  maintainer="Guillaume Noell <gn5@sanger.ak>" \
  description="Docker image for WSTI-HGI scRNA cellbender pipeline"

# nuke cache dirs before installing pkgs; tip from Dirk E fixes broken img
RUN rm -f /var/lib/dpkg/available && rm -rf  /var/cache/apt/*
RUN apt-get update && \
    apt-get install --yes --no-install-recommends \
        wget \
        bzip2 \
        ca-certificates \
        curl \
        git \
        zip \
        unzip \
        procps && \
    apt-get install --yes \
        libpng-dev \
        libcurl4-gnutls-dev \
        libssl-dev \
        libxml2-dev \
        libgit2-dev \
        zlib1g-dev \
        build-essential \
  	procps && \ 
     apt-get purge && \
     apt-get clean && \
     rm -rf /var/lib/apt/lists/*

# install Conda env:
ADD environment.yml /tmp/environment.yml
RUN conda env create -f /tmp/environment.yml

# Set installed Conda env as default:
ENV CONDA_DEFAULT_ENV $conda_env
ENV PATH /opt/conda/envs/$conda_env/bin:$PATH
RUN echo $PATH

# Add additional software using Conda env:
RUN /bin/bash -c "source activate $conda_env \
    && git clone https://github.com/broadinstitute/CellBender.git \
    && pip install -e CellBender \
    && conda env list"

# clean-up  # USER root
RUN conda clean -atipy
RUN rm -rf /tmp/*

# test main software:
RUN cellbender --help
# test main python libraries can be loaded:
RUN python -c 'import sys;print(sys.version_info);import click; import pandas; import plotnine; import matplotlib'

## check software versions:
RUN cd CellBender && git log --pretty=oneline | head >> /usr/conda_software_versions.txt 2>&1
RUN cd CellBender && git describe --tags >> /usr/conda_software_versions.txt 2>&1
RUN /bin/bash -c "source activate $conda_env && conda list --explicit" >> /usr/conda_software_versions.txt 2>&1
RUN cat /usr/conda_software_versions.txt

CMD /bin/sh
