FROM continuumio/miniconda3

COPY config/env/tranx.yml .

RUN conda env create -f tranx.yml

ENTRYPOINT ["/bin/bash"]
