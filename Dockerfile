FROM mambaorg/micromamba:1.5.10-jammy

LABEL org.opencontainers.image.source="https://github.com/martings/SCAPTURE"
LABEL org.opencontainers.image.description="SCAPTURE with native --strand support, DeepPASS TF 2.4 fix, and deterministic Normality seeding"
LABEL org.opencontainers.image.licenses="GPL-3.0-only"

USER root
RUN micromamba install -y -n base \
        -c conda-forge -c bioconda \
        'python=3.8' \
        'numpy=1.19.5' \
        'pandas=1.1.5' \
        'bedtools>=2.26' \
        'samtools>=1.9' \
        'homer>=4.11' \
        'umi_tools>=1.1' \
        'r-base>=4.0' \
        r-nortest \
        r-diptest \
        r-matrix \
        subread \
        stringtie \
        parallel \
        pysam \
        scipy \
        scikit-learn \
        'h5py=2.10.0' \
        ucsc-gtftogenepred \
        ucsc-genepredtobed \
        ucsc-bedtogenepred \
        ucsc-genepredtogtf \
        ucsc-bedsort && \
    micromamba clean --all -y && \
    /opt/conda/bin/pip install --no-cache-dir "tensorflow==2.4.1"

COPY . /opt/scapture
RUN chmod +x \
        /opt/scapture/scapture \
        /opt/scapture/scapture_annotation \
        /opt/scapture/scapture_callpeak \
        /opt/scapture/scapture_evaluate \
        /opt/scapture/scapture_mergesample \
        /opt/scapture/scapture_quant && \
    find /opt/scapture/scripts -maxdepth 2 \( -name "*.py" -o -name "*.sh" \) -exec chmod +x {} +

ENV PATH=/opt/scapture:/opt/conda/bin:$PATH \
    MAMBA_NO_BANNER=1 \
    LC_ALL=C.UTF-8 \
    LANG=C.UTF-8
