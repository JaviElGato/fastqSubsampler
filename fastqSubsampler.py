#!/usr/bin/python3.5
# Author Dr. Javier Gutierrez-Achury - WTSI
# Usage: python fastqSubsampler.py --fastq YOUR_FULL_FASTQ --prop THE_PROPORTION_OF_READS_TO_EXTRACT --outFastq YOUR_SUBSAMPLED_FASTQ

"""
The program will generate 10 randomly subsampled copies. To change this, modify line 52
"""

import argparse
import random
import datetime

parser = argparse.ArgumentParser(description="read fastq, convert into dict and extract porportion of reads")
parser.add_argument("--fastq", dest="fastq")
parser.add_argument("--prop", dest="prop")
parser.add_argument("--outFastq", dest="outFastq")

args = parser.parse_args()

start = datetime.datetime.now()
#print("Start point")
#print(datetime.datetime.now())
fastq = open(args.fastq, 'r+')
prop = args.prop
#outFastq = open(args.outFastq, 'w')
#print(fastq)

prop = int(prop)/100
print("Retreiving reads to list")
#with fastq as input:
#	lines  = input.readlines()
#	items = [item[:-1] for item in lines[::4]]

with fastq as input:
	items = input.readlines()

fastq.close

print("Finish Retreiving")
#print(datetime.datetime.now())

numberOfitems = float(len(items)/4)
totalNumberOfLines = float(len(items))
numberItemsToExtract = int(numberOfitems * prop)


print("Total number of reads: "+str(numberOfitems))
print("Proportion of reads asked to be extracted: "+str(prop))
print("Total Number of reads to be extracted:  "+str(numberItemsToExtract))


for itera in range(1,11):
	print("iteration No. "+str(itera))

	itemsToExtract = sorted(random.sample(range(0,int(numberOfitems)),numberItemsToExtract))
	itemsToExtract = [(x-1) * 4 for x in itemsToExtract]

	print("list with index Ready. Start actual subsampling")

	reads = []

	for line in itemsToExtract:
		reads.append(items[line].split()[0])
		reads.append(items[line+1].split()[0])
		reads.append(items[line+2].split()[0])
		reads.append(items[line+3].split()[0])

	print("Subsampled list ready to output")	


	with open(args.outFastq+"."+str(itera)+"."+"fastq", "w") as output:
		reads = map(lambda x:x+'\n', reads)
		output.writelines(reads)
		#output.writelines("%s" % item for item in reads)

finish = datetime.datetime.now()

print(start)
print(finish)
