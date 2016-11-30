#!/usr/bin/bash

fastqList=$1
prop=$2
infolder=$3
outFolder=$4
#outFastq=$5

currentFolder=`pwd`
mkdir $outFolder
mkdir $outFolder/fastqFiles.Subsample.$prop


#sourcePython

# subsampling fastq files
while read fastq;
do
	echo $fastq	
	#### remember that fastqSubsampler.py will iterate 10 time and the output will be in the format: $outFast.IterNumber.fastq
#		/lustre/scratch113/teams/anderson/users/jga/ToolBox/ScriptsPython/fastqSubsampler.py
	python3.5.0 /lustre/scratch113/teams/anderson/users/jga/ToolBox/fastqSubsampler/fastqSubsampler.py --fastq $infolder/$fastq.fastq --prop $prop --outFastq $outFolder/fastqFiles.Subsample.$prop/$fastq

done < $fastqList

# Organize file in folders per iteration and run transcript counts
for iter in {1..10}; # This number should change if the number of iterations in "fastqSubsampler.py" changes. !!! Take this into account!!!
do
	mkdir $outFolder/subsample.prop_$prop.iter_$iter
	mv $outFolder/fastqFiles.Subsample.$prop/*.$iter.fastq $outFolder/subsample.prop_$prop.iter_$iter
	cd $outFolder/subsample.prop_$prop.iter_$iter
	ls > listOfFiles
	sed '/listOfFiles/d' listOfFiles | sed 's/.fastq//' | sponge listOfFiles
	
	while read mergedFiles;
		do
			echo $mergedFiles
			echo "Spliting reads"
			grep '@.*/1' -A 3 --no-group-separator $mergedFiles.fastq > $mergedFiles.pair1.fastq
			grep '@.*/2' -A 3 --no-group-separator $mergedFiles.fastq > $mergedFiles.pair2.fastq
			rm $mergedFiles.fastq

			mkdir $outFolder/subsample.prop_$prop.iter_$iter/salmonCounts
			echo "counting reads with salmon"
			/lustre/scratch113/teams/anderson/users/jga/ToolBox/RNA_tools/Salmon-0.7.2_linux_x86_64/bin/./salmon quant -i /lustre/scratch113/teams/anderson/users/jga/UsefulFiles/Homo_sapiens.GRCh38.rel79.cdna.all.Salmon.idx -l A -1 $mergedFiles.pair1.fastq -2 $mergedFiles.pair2.fastq -o $outFolder/subsample.prop_$prop.iter_$iter/salmonCounts/$mergedFiles -p 8	

		done < listOfFiles

	cd $currentFolder

done



