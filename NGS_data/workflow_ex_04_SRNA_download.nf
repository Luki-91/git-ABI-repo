nextflow.enable.dsl = 2

params.storeDir="${launchDir}/storeData"
params.accession="SRR1777174"
params.out="$projectDir/output"

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

process makeStats {
	publishDir params.out, mode:"copy", overwrite:true
	container "https://depot.galaxyproject.org/singularity/ngsutils%3A0.5.9--py27h9801fc8_5"
	input:
		path infile
	output:
		path "stats_${infile.getBaseName()}.txt"
	"""
	fastqutils stats $infile > stats_${infile.getBaseName()}.txt
	"""
}

workflow {
  fasterqDump(Channel.from(params.accession)) | flatten | makeStats
}
