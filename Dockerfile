FROM continuumio/miniconda3

COPY config/env/tranx.yml .

RUN conda env create -f tranx.yml

RUN conda activate tranx

RUN python -m nltk.downloader punkt

ENTRYPOINT ["/bin/bash"]
