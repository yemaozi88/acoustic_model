#
# 2017/03/27
# split wav according to its text(.fon)
#
# USAGE
# python split_wav.py [finFon] [finWav] [dirOut]
#
# HISTORY
# 2017/03/31 modified so that the file name is taken as an argument
#
# Aki Kunikoshi
# 428968@gmail.com
#
import sys
import os
import subprocess

#fileFon = 'fn001001.fon'
#dirOut = 'wavPart'
#finBase = fileFon.replace('.fon', '')
args = sys.argv
fileWav = args[1]
fileFon = args[2]
dirOut  = args[3]


## get number of lines
lineNumAll = sum(1 for line in open(fileFon))


## read header
fin = open(fileFon, 'r')

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
	lineNum += 2
	#print timeB + '   ' + timeE

	dur = float(timeE) - float(timeB);
	
	if text != '':			
		# output file names
		finBaseExt = os.path.basename(fileFon)
		finBase = finBaseExt.replace('.fon', '')
		timeB_ = timeB.replace('.', '-')
		foutBase = dirOut + '/' + finBase + '_' + timeB_
		foutTxt = foutBase + '.txt'
		foutWav = foutBase + '.wav'

		#print("%d/%d - %s-%s (%f): %s" % (lineNum, lineNumAll, timeB, timeE, dur, text))
		print("%d/%d %s" % (lineNum, lineNumAll, finBase + '_' + timeB_))

		# split wav file
		subprocessStr = 'sox ' + fileWav + ' ' + foutWav + ' trim ' + timeB + ' ' + str(dur)
		subprocess.call(subprocessStr, shell=True)
		
		# output text
		fout = open(foutTxt, 'w')
		fout.write(text)
		fout.close

fin.close