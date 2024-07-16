# VRSAnnotator

### Description
GA4GH VRS identifiers provide a standardized way to represent genomic variations, making it easier to exchange, harmonize, and integrate genomic information. 

This workflow provides a way for you to annotate a VCF with GA4GH Variation Representation Specification (VRS) Allele IDs! Varying configuration such as genome assemvly, a VRS ID is created for both the reference and alternate allele for each variant.

This can be easily run with the [VRS AnVIL](https://app.terra.bio/#workspaces/terra-test-bwalsh/vrs_anvil_toolkit) workspace, which provides tools to enable the use of GA4GH VRS IDs on the Terra platform.

### Inputs
- `input_vcf_path` (File): Google resource path of VCF file (gs://)
- `output_vcf_name` (String): Name of annotated VCF file with its file extension (vcf.gz)
- `seqrepo_tarball` (File, optional): Google resource path for seqrepo tarball (tar.gz). Defaults to tarball stored in the requestor pays VRS AnVIL Workspace.
- `compute_for_ref` (boolean, optional): Whether to compute both the ref and alt allele or compute only the alt allele for each variant. Defaults to true, computing both.
- `genome_assembly` (String, optional): enome assembly or genome build used by the VCF. Defaults to "GRCh38", but "GRCh37" is also supported.