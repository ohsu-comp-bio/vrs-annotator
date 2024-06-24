# Example workflow
# Declare WDL version 1.0 if working in Terra
version 1.0
workflow VRSAnnotator {
    input {
        String input_vcf_path
        String output_vcf_path
    }

    call annotate { 
        input:
            input_vcf_path = input_vcf_path,
            output_vcf_path = output_vcf_path
    }
}

task annotate {
    input {
        String input_vcf_path
        String output_vcf_path
    }

    command <<<
        SEQREPO_DIR=~/seqrepo
        mkdir $SEQREPO_DIR
        seqrepo --root-directory $SEQREPO_DIR pull --update-latest
        python -m ga4gh.vrs.extras.vcf_annotation --vcf_in ~{input_vcf_path} --vcf_out ~{output_vcf_path} --seqrepo_root_dir $SEQREPO_DIR/latest
        bcftools index -t ~{output_vcf_path}
    >>>

    runtime {
        docker: 'quay.io/ohsu-comp-bio/vrs-annotator:base'
    }
}