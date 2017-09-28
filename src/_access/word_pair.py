#
# 2017/05/25
# make a list of sentences based on .fon/.ort file.
#
# USAGE
# python list_sentence.py [fin] [fout]
#
# HISTORY
# 2017/05/25 this file was made based on split_wav.py
#
# Aki Kunikoshi
# 428968@gmail.com
#
import sys
import os
import subprocess

args = sys.argv
fileIn  = args[1]
fileOut = args[2]


## get number of lines
lineNumAll = sum(1 for line in open(fileIn))


## read header
fin  = open(fileIn, 'r')
fout = open(fileOut, 'w')

isIntervalTier = 0
lineNum = 0
while (isIntervalTier == 0):	
	# load one line.
	line = fin.readline()
	lineNum += 1
	# remove the CRLF at the end of the line.
	line2 = line.rstrip('\r\n')
	
	if line2 == '"IntervalTier"':
		isIntervalTier = 1
		for j in range (1, 5):
			line = fin.readline()
			lineNum += 1


## read every 3 lines - timeB, timeE and text.
while ( lineNum < lineNumAll ):
	line  = fin.readline()
	timeB = line.rstrip('\r\n')
	lineNum += 1
	if timeB == '"IntervalTier"':
		timeB = '0.000'
		for j in range (1, 6):
			fin.readline()
			lineNum += 1
	
	line  = fin.readline()
	timeE = line.rstrip('\r\n')
	line  = fin.readline()	
	text  = line.rstrip('\r\n')
	text  = text.replace('"', '')
	text  = text.replace('.', '')
	lineNum += 2

	dur = float(timeE) - float(timeB);
	
	if text != '':			
		# output file names
		finBaseExt = os.path.basename(fileIn)
		finBase_ = finBaseExt.split('.')
		finBase  = finBase_[0]

		## output text
		#print("%s, %s, %s: %s" % (finBase, timeB, timeE, text))
		buf = "%s,%s,%s,%s\n" % (finBase, timeB, timeE, text)
		fout.write(buf)
		
fout.close
fin.close
