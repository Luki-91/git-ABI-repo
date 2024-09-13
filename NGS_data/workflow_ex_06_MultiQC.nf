nextflow.enable.dsl =2

params.accession = "SRR1777174"
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
	when:
		params.with_fastqc
	"""
	fastqc $fastqfile
	"""
}

process makeStats {
	publishDir params.out, mode:"copy", overwrite:true
	container "https://depot.galaxyproject.org/singularity/ngsutils%3A0.5.9--py27h9801fc8_5"
	input:
		path infile
	output:
		path "stats_${infile.getBaseName()}.txt"
	when:
		params.with_stats
	"""
	fastqutils stats $infile > stats_${infile.getBaseName()}.txt
	"""
}

process trim_fastp {
	publishDir params.out, mode:"copy", overwrite:true
	container "https://depot.galaxyproject.org/singularity/fastp%3A0.23.4--hadf994f_3"
	input:
		path infile
    output:
        path "trimmed_${infile.getBaseName()}.*"
	"""
	fastp -i $infile -o trimmed_${infile.getBaseName()}.fastq
	"""
}


workflow {
	dumpChannel = fasterqDump(Channel.from(params.accession))
	trimChannel = trim_fastp(dumpChannel)
	qcChannel = dumpChannel.concat(trimChannel)
	fastqc(qcChannel.flatten())
	makeStats(qcChannel.flatten())
}