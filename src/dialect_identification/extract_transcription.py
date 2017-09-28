#
# 2017/07/31
#
# Aki Kunikoshi
# 428968@gmail.com
#
import sys
import os

args = sys.argv
fileIn  = args[1]
fileOut = args[2]
#fileIn = '/home/Aki/_same-utterance/wav/01/Groningen_and_Drenthe/28-1449002700-1825.txt'
#fileOut = '/home/Aki/_same-utterance/wav/01/Groningen_and_Drenthe/28-1449002700-1825.out'

## output file names
#dirIn = os.path.dirname(fileIn)
finBaseExt = os.path.basename(fileIn)
finBase = finBaseExt.replace('.txt', '')
#finName  = dirIn + '/' + finBase + '.txt' 
#foutName = dirIn + '/' + finBase + '.lab'


## open files
fin  = open(fileIn, 'r')
fout = open(fileOut, 'w')
fout.write("%s" % finBase)
	
# first two lines are not related to duration
line = fin.readline()
line = fin.readline()

pron = ''
while line:
	line = fin.readline()
	line = line.rstrip()
	x = line.split()

	# durStart durEnd phoneme likelihood word
	if len(x) == 1:
		#print pron
		fout.write("%s," % pron)
	elif len(x) == 4:
		if x[2] != 'ssil':
			pron = pron + x[2]
	elif len(x) == 5:
		#print pron
		fout.write("%s," % pron)

		word = x[4]
		pron = ''
		#print word
#fout.write("\n")

fout.close()
fin.close()