# VRSAnnotator

### Description
Annotate a VCF with GA4GH Variation Representation Specification (VRS) Allele IDs! For each variant, a VRS ID is created for both the reference and alternate allele for each variant.

GA4GH VRS identifiers provide a standardized way to represent genomic variations, making it easier to exchange and share genomic information. This can be easily run with the [vrs_anvil_toolkit](https://app.terra.bio/#workspaces/terra-test-bwalsh/vrs_anvil_toolkit) workspace, which provides tools to enable the use of GA4GH VRS IDs on the Terra platform.

### Inputs
- `input_vcf_path`: Google resource path of VCF (gs://)
- `output_vcf_name`: name of annotated VCF file with its file extension (vcf.gz)
- `seqrepo_zip`: Google resource path for seqrepo tarball (tar.gz)