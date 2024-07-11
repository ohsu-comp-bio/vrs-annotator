# Example workflow
# Declare WDL version 1.0 if working in Terra
version 1.0
workflow VRSAnnotator {
    input {
        File input_vcf_path
        String output_vcf_name 
        File seqrepo_tarball
    }

    call annotate {
        input:
            input_vcf_path = input_vcf_path,
            output_vcf_name = output_vcf_name,
            seqrepo_tarball = seqrepo_tarball
    }
}

task annotate {
    input {
        File input_vcf_path
        String output_vcf_name
        File seqrepo_tarball
    }

    command <<<
        # if compressed input VCF, create index
        if [[ ~{input_vcf_path} == *.gz ]]; then
            echo "creating index for input VCF"
            bcftools index -t ~{input_vcf_path}
        fi

        # setup seqrepo
        SEQREPO_DIR=~/seqrepo
        echo "unzipping seqrepo"

        if [[ ! ~{seqrepo_tarball} == *.tar.gz && ! ~{seqrepo_tarball} == *.tgz ]]; then
            echo "ERROR: expected seqrepo to be a tarball (tar.gz or tgz) file"
            exit 1
        fi

        sudo tar -xzf ~{seqrepo_tarball} --directory=$HOME
        sudo chown "$(whoami)" $SEQREPO_DIR
        seqrepo --root-directory $SEQREPO_DIR update-latest

        # annotate and index vcf
        python -m ga4gh.vrs.extras.vcf_annotation --vcf_in ~{input_vcf_path} --vcf_out ~{output_vcf_name} --seqrepo_root_dir $SEQREPO_DIR/latest
        bcftools index -t ~{output_vcf_name}
    >>>

    runtime {
        docker: "quay.io/ohsu-comp-bio/vrs-annotator:base"
        disks: "local-disk 50 SSD"
        bootDiskSizeGb: 20
    }

    output {
        File annotated_vcf = "~{output_vcf_name}"
        File annotated_vcf_index = "~{output_vcf_name}.tbi"
    }
}