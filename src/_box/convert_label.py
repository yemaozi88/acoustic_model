#
# 2017/03/30
#
# Aki Kunikoshi
# 428968@gmail.com
#
import sys
import os

args = sys.argv
fileTxt = args[1]

diftong = ['E+', 'Y+', 'A+']
leen 	= ['E:', 'Y:', 'O:']
nasal 	= ['E~', 'A~', 'O~', 'Y~']

# output file names
dirIn = os.path.dirname(fileTxt)
finBaseExt = os.path.basename(fileTxt)
finBase = finBaseExt.replace('.txt', '')
finName  = dirIn + '/' + finBase + '.txt' 
foutName = dirIn + '/' + finBase + '.lab'


## open input file
fin  = open(finName, 'r')
line = fin.readline()

# if the following sound is included, do nothing
if line.find('#') == -1 and line.find('[') == -1 and line.find('-') == -1:
	## open output file
	fout = open(foutName, 'w')
	fout.write('silB\n')

	charNumMax = len(line)
	charNum = 0
	while charNum < charNumMax-1:
		charThis = line[charNum]
		charPair = line[charNum] + line[charNum+1]

		if charPair in diftong or charPair in leen or charPair in nasal :
			if charNum+2 < charNumMax-1 and line[charNum+2] == '_':
				charNum += 5
			else:
				charNum += 2
			fout.write(charPair + '\n')
		elif charThis == ' ':
			fout.write('sp\n')
			charNum += 1
		elif charThis == '2':
			fout.write('C\n') # in HTK phone shouldn't start with number
			charNum += 1
		else:
			if charNum+2 < charNumMax-1 and line[charNum+1] == '_':
				charNum += 3
			else:
				charNum += 1
			fout.write(charThis + '\n')
	#if charNum == charNumMax-1:
	fout.write('silE\n')
	#fout.write('.\n')
	fout.close

fin.close
