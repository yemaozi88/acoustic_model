#
# 2017/08/08
# convert forced alignment made by HTK to TextGrid for Praat.
#
# Aki Kunikoshi
# 428968@gmail.com
#
import sys
import os
import numpy as np

args = sys.argv
fileIn  = args[1]
fileOut = args[2]
#fileIn  = 'sample.txt'
#fileOut = 'sample.fon'

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
# line = fin.readline()
# line = fin.readline()
lines = fin.read()
fin.close()

# load lines
lines = lines.split('\n')
lineNumMax = len(lines)

# first two lines are header
intervalNumMaxPhone = 0
intervalNumMaxWord  = 0
for i in range(2, lineNumMax):
	line = lines[i].rstrip()
	
	# x: durStart durEnd phoneme likelihood word
	x = line.split(' ')
	#if len(x) > 3 and x[2] != 'ssil':
	#	intervalNumMax += 1
	#print("{0}_{1}:{2}".format(i, len(x), lines[i]))

	if len(x) >= 4:
		intervalNumMaxPhone += 1
		intervalEnd = float(x[1])/1000

	if len(x) == 5:
		intervalNumMaxWord += 1

#print("Number of phones: %d" % intervalNumMaxPhone) 
#print("Number of words: %d" % intervalNumMaxWord) 
#print("Interval end: %f" % intervalEnd) 


# header
fout.write('File type = \"ooTextFile short\"\n')
fout.write('\"TextGrid\"\n\n')
fout.write('0.000\n') # intervalStart
fout.write('%.3f\n' % intervalEnd)
fout.write('<exists>\n') # TextGrid contains Tiers
fout.write('2\n') # number of Tiers included in TextGrid


# IntervalTier (phone)
fout.write('\"IntervalTier\"\n')
fout.write('\"Phones\"\n')
fout.write('0.000\n') # intervalStart
fout.write('%.3f\n' % intervalEnd)
fout.write('%d\n' % intervalNumMaxPhone)

intervalPeriod = np.zeros((intervalNumMaxPhone, 2))
intervalWordStart = np.zeros((intervalNumMaxWord, 1), dtype='int32')
intervalWord = []
j = 0
for i in range(0, intervalNumMaxPhone):
	line = lines[i+2].rstrip()
	
	# x: durStart durEnd phoneme likelihood word
	x = line.split(' ')
	intervalStart = float(x[0])/1000
	intervalEnd   = float(x[1])/1000
	fout.write('%.3f\n' % intervalStart)
	fout.write('%.3f\n' % intervalEnd)
	if x[2] == 'ssil':
		fout.write('\"\"\n')
	else:
		fout.write('\"%s\"\n' % x[2])   # phone
	
	# information for IntervalTier (word)
	intervalPeriod[i, 0] = intervalStart
	intervalPeriod[i, 1] = intervalEnd
	if len(x) == 5:
		intervalWordStart[j, 0] = i
		intervalWord.append(x[4])
		j += 1
#print intervalPeriod
#print intervalWordStart
#print intervalWord

# IntervalTier (word)
fout.write('\"IntervalTier\"\n')
fout.write('\"Words\"\n')
fout.write('0.000\n') # intervalStart
fout.write('%.3f\n' % intervalEnd)
fout.write('%d\n' % intervalNumMaxWord)

for i in range(0, intervalNumMaxWord):
	intervalStartIndex = intervalWordStart[i]
	if i < intervalNumMaxWord-1:
		intervalEndIndex = intervalWordStart[i+1]-1
	else:
		intervalEndIndex = intervalNumMaxPhone-1
	word = intervalWord[i]
	
	#print("{0}_{1}-{2}:{3}".format(i, intervalStartIndex, intervalEndIndex, word))
	intervalStart = intervalPeriod[intervalStartIndex, 0]
	intervalEnd   = intervalPeriod[intervalEndIndex, 1]
	fout.write('%.3f\n' % intervalStart)
	fout.write('%.3f\n' % intervalEnd)	
	fout.write('\"%s\"\n' % word)
fout.close()

