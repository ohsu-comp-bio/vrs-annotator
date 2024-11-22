# [DEPRECATED] VRSAnnotator

## We have moved! This will not longer be maintained, but will be kept up for existing Dockstore Workflow users to transition over. See the new repo on [gks-anvil](https://github.com/gks-anvil/vrs-annotator).

## Steps for Current Users to Transition 

If you have already imported this workflow into a Terra Workspace, here are some quick steps to update your workflow...

1. Navigate to the Workflows tab of the Workspace
2. Save your preferred inputs
   1. Select the INPUTS tab and click "Download json"
   2. Select the OUTPUTS tab and click "Download json"
3. Import the new Dockstore repo for [VRSAnnotator](https://dockstore.org/workflows/github.com/gks-anvil/vrs-annotator/VRSAnnotator:main?tab=info)
   1. Visit [Dockstore](https://dockstore.org/workflows/github.com/gks-anvil/vrs-annotator/VRSAnnotator:main?tab=info)
   2. On the right-hand side, click the Terra button in the "Launch with" section
   3. Choose the Desination Workspace using the dropdown
   4. Click Overwrite
4. Update your preferred inputs and outputs using "upload json"
5. Enjoy workflowing 🥳

## [DEPRECATED: SEE ABOVE]

### Description
GA4GH VRS identifiers provide a standardized way to represent genomic variations, making it easier to exchange, harmonize, and integrate genomic information. 

This WDL workflow wraps the functionality of vrs-python's [vcf_annotator](https://github.com/ga4gh/vrs-python/blob/main/docs/extras/vcf_annotator.md), allowing you to annotate Variant Call Format (VCF) files with GA4GH Variation Representation Specification (VRS) Allele IDs on Terra! This makes integration of genomic variant data with downstream evidence data like [MetaKB](https://search.cancervariants.org/) much easier.

To get started, navigate to the [VRS AnVIL](https://app.terra.bio/#workspaces/terra-test-bwalsh/vrs_anvil) workspace to run it on Terra! For more details, see the docs on [setting up a Terra workflow](https://support.terra.bio/hc/en-us/articles/360036379771-Overview-Running-workflows-in-Terra) and the Dockstore repository for the [VRS Annotator workflow](https://dockstore.org/my-workflows/github.com/ohsu-comp-bio/vrs-annotator/VRSAnnotator).

### Inputs
- `input_vcf_path` (File): Google resource path of VCF file (gs://)
- `output_vcf_name` (String): Name of annotated VCF file with its file extension (vcf.gz)
- `seqrepo_tarball` (File, optional): Google resource path for seqrepo tarball (tar.gz). Defaults to tarball stored in the requestor pays VRS AnVIL Workspace.
- `compute_for_ref` (boolean, optional): Whether to compute both the ref and alt allele or compute only the alt allele for each variant. Defaults to true, computing both.
- `vrs_attributes` (boolean, optional): Whether to compute both the ref and alt allele or compute only the alt allele for each variant. Defaults to true, computing both.
- `genome_assembly` (String, optional): genome assembly or genome build used by the VCF. Defaults to "GRCh38", but "GRCh37" is also supported.


## Outputs
To write output file paths to directly to a Terra data table, specify the outputs, specifically:
- `output_vcf` (File): column in a Terra data table to write the output VCF to
- `output_vcf_index` (File): column in a Terra data table to write the tabix output VCF index to

For more info on how to write workflow ouputs to the data table, see the [Terra docs](https://support.terra.bio/hc/en-us/articles/4500420806299-Writing-workflow-outputs-to-the-data-table)
