#
# 2017/05/08
# convert 100ns unig to ms in HTK forced alignment output 
#
# Aki Kunikoshi
# 428968@gmail.com
#
import sys
import os

args = sys.argv
fileIn  = args[1]
fileOut = args[2]


## output file names
#dirIn = os.path.dirname(fileIn)
#finBaseExt = os.path.basename(fileIn)
#finBase = finBaseExt.replace('.txt', '')
#finName  = dirIn + '/' + finBase + '.txt' 
#foutName = dirIn + '/' + finBase + '.lab'


## open files
fin  = open(fileIn, 'r')
fout = open(fileOut, 'w')
	
# first two lines are not related to duration
line = fin.readline()
fout.write(line)
line = fin.readline()
fout.write(line)

while line:
	line = fin.readline()
	dur = line.split()
	# durStart durEnd phoneme likelihood phoneme
	if len(dur) == 4 or len(dur) == 5:
		# convert 100ns -> ms
		dur[0] = float(dur[0])/10000
		dur[1] = float(dur[1])/10000
		if len(dur) == 4:
			fout.write('{0} {1} {2} {3}\n'.format(dur[0], dur[1], dur[2], dur[3]))
		elif len(dur) == 5:
			fout.write('{0} {1} {2} {3} {4}\n'.format(dur[0], dur[1], dur[2], dur[3], dur[4]))
	else:
		fout.write(line)

fout.close()
fin.close()
