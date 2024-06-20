# Example workflow
# Declare WDL version 1.0 if working in Terra
version 1.0
workflow VRSAnnotator {
    input {
        String input_vcf_path
        String output_vcf_path
        String seqrepo_root_dir
    }

    call annotate {
        input:
            seqrepo_root_dir = seqrepo_root_dir,
            input_vcf_path = input_vcf_path,
            output_vcf_path = output_vcf_path
    }
}

task annotate {
    input {
        String input_vcf_path
        String output_vcf_path
        String seqrepo_root_dir
    }

    command <<<
        python -m venv venv
        source venv/bin/activate
        source ~/projects/vrs_anvil_toolkit/venv/bin/activate
        
        python3 -m ga4gh.vrs.extras.vcf_annotation --vcf_in ~{input_vcf_path} --vcf_out ~{output_vcf_path} --seqrepo_root_dir ~{seqrepo_root_dir}
        bcftools index -t ~{output_vcf_path}
        
        deactivate
    >>>

    output {
        String out = read_string(stdout())
    }
}