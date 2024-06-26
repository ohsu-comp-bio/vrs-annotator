FROM circleci/python:3.10

# Clone repositories and build bcftools
RUN cd ~ && \
    git clone --recurse-submodules https://github.com/samtools/htslib.git && \
    git clone https://github.com/samtools/bcftools.git && \
    cd bcftools && \
    autoheader && autoconf && ./configure prefix=$HOME && \
    make && \
    make install && \
    export BCFTOOLS_PLUGINS=~/bcftools/plugins/

RUN pip install ga4gh.vrs[extras]==2.0.0a7 biocommons.seqrepo

RUN sudo apt-get update && sudo apt-get install -y rsync

CMD ["/bin/bash"]