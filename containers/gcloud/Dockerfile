FROM google/cloud-sdk:stable-alpha

# get dependencies
RUN apt-get update && \
    apt-get install -y python3 \
        git-all \
        # for bcftools make
        build-essential \
        ca-certificates \
        make \
        cmake \
        moreutils \
        gnupg \
        autoconf \
        zlib1g-dev \
        liblzma-dev \
        libcurl4-openssl-dev \
        libbz2-dev \
        liblzma-dev \
        # for seqrepo download
        rsync
        curl

# build bcftools
RUN cd ~ && \
    git clone --recurse-submodules https://github.com/samtools/htslib.git && \
    git clone https://github.com/samtools/bcftools.git && \
    cd bcftools && \
    autoheader && autoconf && ./configure --prefix=$HOME && \
    make && \
    make install && \
    export BCFTOOLS_PLUGINS=~/bcftools/plugins/ && \
    export PATH=~/bin/:$PATH


# install vrs and seqerepo from pip
RUN cd ~ && \
    apt-get install -y pip python3-venv libpq-dev && \
    pip install --break-system-packages ga4gh.vrs[extras]==2.0.0a7 biocommons.seqrepo



# Set the working directory
WORKDIR $HOME

CMD ["/bin/bash"]