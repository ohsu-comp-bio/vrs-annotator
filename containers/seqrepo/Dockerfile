FROM quay.io/ohsu-comp-bio/vrs-annotator:base

RUN cd ~ && \
    SEQREPO_DIR="${HOME}/seqrepo/" && \
    mkdir $SEQREPO_DIR && \
    seqrepo --root-directory $SEQREPO_DIR pull --update-latest

CMD ["/bin/bash"]