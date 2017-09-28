#
# 2017/03/27
# split wav according to its text(.fon)
#
# USAGE
# python split_wav.py [finFon] [finWav] [dirOut]
#
# HISTORY
# 2017/08/13 instead of (line number)/3, interval numbers are loaded from the hearder of each IntervalTier. So, all the lines related to lineNum are removed.
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
#lineNumAll = sum(1 for line in open(fileFon))

## read until 'intervalTier'
fin = open(fileFon, 'r')
isIntervalTier = 0
#lineNum = 0
while (isIntervalTier == 0):	
	# load one line.
	line = fin.readline()
	#lineNum += 1
	# remove the CRLF at the end of the line.
	line = line.rstrip('\r\n')
	
	if line == '"IntervalTier"':
		isIntervalTier = 1
		#for j in range (1, 5):
		#	line = fin.readline()
		#	lineNum += 1

		line = fin.readline()
		tierName = line.rstrip('\r\n')
		line = fin.readline()
		tierStart_sec = float(line.rstrip('\r\n'))
		line = fin.readline()
		tierEnd_sec   = float(line.rstrip('\r\n'))
		line = fin.readline()
		intervalNumMax = int(line.rstrip('\r\n'))
		# print('tierName: {0}'.format(tierName))
		# print('tierStart_sec: {0}'.format(tierStart_sec))
		# print('tierEnd_sec: {0}'.format(tierEnd_sec))
		# print('intervalNumMax: {0}'.format(intervalNumMax))

## read every 3 lines - timeB, timeE and text.
# while ( lineNum < lineNumAll ):
for intervalNum in range (1, intervalNumMax+1):
	# line  = fin.readline()
	# timeB = line.rstrip('\r\n')
	# lineNum += 1
	# if timeB == '"IntervalTier"':
		# timeB = '0.000'
		# for j in range (1, 6):
			# fin.readline()
			# lineNum += 1
	line = fin.readline()
	timeB = line.rstrip('\r\n')
	line  = fin.readline()
	timeE = line.rstrip('\r\n')
	line  = fin.readline()	
	text  = line.rstrip('\r\n')
	text  = text.replace('"', '')
	# lineNum += 2
	#print('({0}) {1}-{2} :{3}'.format(intervalNum, timeB, timeE, text))

	dur = float(timeE) - float(timeB);
	
	if text != '':			
		# create output file names
		finBaseExt = os.path.basename(fileFon)
		finBase = finBaseExt.replace('.fon', '')
		timeB_ = timeB.replace('.', '-')
		foutBase = dirOut + '/' + finBase + '_' + timeB_
		foutTxt = foutBase + '.txt'
		foutWav = foutBase + '.wav'

		print("%d/%d %s" % (intervalNum, intervalNumMax, finBase + '_' + timeB_))

		# split wav file
		subprocessStr = 'sox ' + fileWav + ' ' + foutWav + ' trim ' + timeB + ' ' + str(dur)
		subprocess.call(subprocessStr, shell=True)
		
		# output text
		fout = open(foutTxt, 'w')
		fout.write(text)
		fout.close

fin.close