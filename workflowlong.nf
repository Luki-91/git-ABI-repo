nextflow.enable.dsl=2
params.out = "$launchDir/output"

process downloadFile {
    publishDir params.out, mode :"copy", overwrite: true
    output:
        path "batch1.fasta"
    """
    wget https://tinyurl.com/cqbatch1 -O batch1.fasta
    """
}

process countSequences {
    publishDir params.out, mode :"copy", overwrite: true
	input:
		path infile
    output:
		path "numseqs.txt"
	"""
	grep "^>" $infile | wc -l > numseqs.txt
	"""
}

process splitseqs {
	publishDir params.out, mode :"copy", overwrite: true
	input:
		path infile1
	output:
		path "prefix_*.fasta"
	
	"""
	split -d -l 2 $infile1 prefix_ --additional-suffix=.fasta
	"""
}

process countrepeats {
	publishDir params.out, mode:"copy", overwrite: true
	input: 
		path infile
	output:
		path ${infasta.getSimpleName()}_countrepeats.txt
	"""
	grep -o infile "GCCGCG" | wc -l > ${infasta.getSimpleName()}_countrepeats*.txt
	"""
}

workflow {
	filechannel = downloadFile()
	countSequences(filechannel)
	splitseqs(filechannel) | flatten | countrepeats
}