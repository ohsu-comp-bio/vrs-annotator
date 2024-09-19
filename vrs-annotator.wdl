# Example workflow
# Declare WDL version 1.0 if working in Terra
version 1.0
workflow VRSAnnotator {
    input {
        File input_vcf_path
        String output_vcf_name 
        File seqrepo_tarball
        Boolean compute_for_ref = true
        Boolean compute_vrs_attributes = true
        String genome_assembly = "GRCh38"
    }

    call annotate {
        input:
            input_vcf_path = input_vcf_path,
            output_vcf_name = output_vcf_name,
            seqrepo_tarball = seqrepo_tarball,
            compute_for_ref = compute_for_ref,
            compute_vrs_attributes = compute_vrs_attributes,
            genome_assembly = genome_assembly
    }
}

task annotate {
    input {
        File input_vcf_path
        String output_vcf_name
        File seqrepo_tarball
        Boolean compute_for_ref
        Boolean compute_vrs_attributes
        String genome_assembly
    }

    Int disk_size = ceil(size(input_vcf_path, "GB") + size(seqrepo_tarball, "GB") + 10)

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

        # add runtime flags if specified
        if ~{compute_for_ref}; then
            REF_FLAG="--skip_ref"
        fi
        
        if ~{compute_vrs_attributes}; then
            VRS_ATTRIBUTES_FLAG="--vrs_attributes"
        fi

        # annotate and index vcf
        python -m ga4gh.vrs.extras.vcf_annotation \
            --vcf_in ~{input_vcf_path} \
            --vcf_out ~{output_vcf_name} \
            --seqrepo_root_dir $SEQREPO_DIR/latest \
            --assembly ~{genome_assembly} \
            $REF_FLAG \
            $VRS_ATTRIBUTES_FLAG
        
        bcftools index -t ~{output_vcf_name}
    >>>

    output {
        File annotated_vcf = "~{output_vcf_name}"
        File annotated_vcf_index = "~{output_vcf_name}.tbi"
    }
}