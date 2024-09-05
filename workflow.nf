nextflow.enable.dsl=2

process downloadFile {
    publishDir "/home/julia/Module_Git_with_Wojtek/git-ABI-repo", mode :"copy", overwrite: true
    output:
        path "batch1.fasta"
    """
    wget https://tinyurl.com/cqbatch1 -O batch1.fasta
    """
}

process countSequences {
    publishDir "/home/julia/Module_Git_with_Wojtek/git-ABI-repo", mode :"copy", overwrite: true
	input:
		path infile
    output:
		path "numseqs.txt"
	"""
	grep "^>" $infile | wc -l > numseqs.txt
	"""
}

workflow {
    downloadFile | countSequences
}