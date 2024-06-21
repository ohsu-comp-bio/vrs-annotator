# Example workflow
# Declare WDL version 1.0 if working in Terra
version 1.0
workflow VRSAnnotator {
    input {
        String input_vcf_path
        String output_vcf_path
        String seqrepo_root_dir = "~/seqrepo"
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
        pip install ga4gh.vrs[extras]==2.0.0a7 biocommons.seqrepo

        mkdir ~{seqrepo_root_dir}
        seqrepo --root-directory ~{seqrepo_root_dir} pull --update-latest
        
        python3 -m ga4gh.vrs.extras.vcf_annotation --vcf_in ~{input_vcf_path} --vcf_out ~{output_vcf_path} --seqrepo_root_dir ~{seqrepo_root_dir}
        # bcftools index -t ~{output_vcf_path}
    >>>
}