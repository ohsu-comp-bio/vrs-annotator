# VRSAnnotator

### Description
Annotate a VCF with VRS Allele IDs! For each variant, a VRS ID is created for both the reference and alternate allele

### Inputs
- `input_vcf_path`: as a Google resource path (gs://)
- `output_vcf_name`: name of annotated VCF file with its file extension (vcf or vcf.gz)
- `preload_seqrepo` [optional, default=True]: whether to load a Docker image with reference sequence database (seqrepo) preloaded or whether to download seqrepo during execution. Default performance is slightly better (20min vs 30min), but the advantage of not preloading is getting the most recent version if an infrequent update does happen to occur in the seqrepo database.