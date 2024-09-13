nextflow.enable.dsl =2

// params.accession = "SRR1777174"
params.accession = null
params.out = "$projectDir/output"
params.storeDir = "$projectDir/dataStore"
params.with_fastqc = false
params.with_stats = false

process fasterqDump {
  storeDir params.storeDir
  container "https://depot.galaxyproject.org/singularity/sra-tools%3A2.11.0--pl5321ha49a11a_3"
  input:
    val accession
  output:
    path "${accession}*.fastq"
  script:
  """
  fasterq-dump --split-3 $accession
  """
}

process fastqc {
	publishDir params.out, mode:"copy", overwrite:true
	container "https://depot.galaxyproject.org/singularity/fastqc%3A0.12.1--hdfd78af_0"
	input: 
		path fastqfile
	output:
		path "${fastqfile.baseName}_fastqc.*"
	// why doesn't it work with ${params.accesion}/{fastqfile.baseName}_fastqc.*
	"""
	fastqc $fastqfile
	"""
}

workflow {
	if (params.accession == null) {
		print "Error: please provide the accession number"
		System exit (0)
	}
	// if (params.withFastqc
	fasterqDump(Channel.from(params.accession)) | fastqc
}
//Also did not work with flatten in between fasterqDump and fastqc, for whatever reason