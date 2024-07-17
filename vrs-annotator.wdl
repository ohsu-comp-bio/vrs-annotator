# Example workflow
# Declare WDL version 1.0 if working in Terra
version 1.0
workflow VRSAnnotator {
    input {
        File input_vcf_path
        String output_vcf_name 
        File seqrepo_tarball
        Boolean compute_for_ref = true
        String genome_assembly = "GRCh38"
    }

    call annotate {
        input:
            input_vcf_path = input_vcf_path,
            output_vcf_name = output_vcf_name,
            seqrepo_tarball = seqrepo_tarball,
            compute_for_ref = compute_for_ref,
            genome_assembly = genome_assembly
    }
}

task annotate {
    input {
        File input_vcf_path
        String output_vcf_name
        File seqrepo_tarball
        Boolean compute_for_ref
        String genome_assembly
    }

    Int disk_size = ceil(size(input_vcf_path, "GB")) + ceil(size(seqrepo_tarball, "GB")) + 10

    runtime {
        docker: "quay.io/ohsu-comp-bio/vrs-annotator:base"
        disks: "local-disk " + disk_size + " SSD"
        bootDiskSizeGb: disk_size
        memory: "8G"
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
        if ~{compute_for_ref}; then
            python -m ga4gh.vrs.extras.vcf_annotation \
                --vcf_in ~{input_vcf_path} \
                --vcf_out ~{output_vcf_name} \
                --seqrepo_root_dir $SEQREPO_DIR/latest \
                --assembly ~{genome_assembly}
        else
            echo "annotating only alt without ref"
            python -m ga4gh.vrs.extras.vcf_annotation \
                --vcf_in ~{input_vcf_path} \
                --vcf_out ~{output_vcf_name} \
                --seqrepo_root_dir $SEQREPO_DIR/latest \
                --skip_ref \
                --assembly ~{genome_assembly}
        fi
        
        bcftools index -t ~{output_vcf_name}
    >>>

    output {
        File annotated_vcf = "~{output_vcf_name}"
        File annotated_vcf_index = "~{output_vcf_name}.tbi"
    }
}