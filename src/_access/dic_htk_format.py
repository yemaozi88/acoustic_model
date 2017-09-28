#
# 2017/03/30
#
# Aki Kunikoshi
# 428968@gmail.com
#

import sys
import os
import re

# input file
args = sys.argv
fileIn  = args[1]
fileOut = args[2]

# seperate line into phones
def seperate_phones( line ):
	#diftong = ['E+', 'Y+', 'A+']
	#leen 	= ['E:', 'Y:', 'O:']
	#nasal 	= ['E~', 'A~', 'O~', 'Y~']

	# replace all phones with two characters with a single charactor.
	line = line.replace('A+', 'B')
	line = line.replace('A~', 'D')
	
	line = line.replace('E+', 'F')
	line = line.replace('E:', 'H')
	line = line.replace('E~', 'J')
	
	line = line.replace('O:', 'K')
	line = line.replace('O~', 'L')
	
	line = line.replace('U~', 'M')
	
	line = line.replace('Y+', 'P')
	line = line.replace('Y:', 'Q')
	
	# replace short pause with X
	line = line.replace(' ', 'X')	
	
	# htk outputs error when a phone starts with number
	line = line.replace('2', 'C') 
	
	# assume *_* as one phone *
	line = line.replace('_', '')
	
	lineSeperated = line[0]
	for charNum in range(1, len(line)):
		lineSeperated = lineSeperated + " " + line[charNum]
	
	# replace back phones with two characters
	lineSeperated = lineSeperated.replace('B', 'A+')
	lineSeperated = lineSeperated.replace('D', 'A~')
	
	lineSeperated = lineSeperated.replace('F', 'E+')
	lineSeperated = lineSeperated.replace('H', 'E:')
	lineSeperated = lineSeperated.replace('J', 'E~')
	
	lineSeperated = lineSeperated.replace('K', 'O:')
	lineSeperated = lineSeperated.replace('L', 'O~')
	
	lineSeperated = lineSeperated.replace('M', 'U~')
	
	lineSeperated = lineSeperated.replace('P', 'Y+')
	lineSeperated = lineSeperated.replace('Q', 'Y:')
	
	# short pause
	lineSeperated = lineSeperated.replace('X', 'sp')	
	
	return lineSeperated


# file I/O
fin  = open(fileIn, 'r')
line = fin.readline()

fout = open(fileOut, 'w')

lineNum = 1;
while line:
	line = fin.readline()
	lineNum += 1
	
	# remove the CRLF at the end of the line.
	line = line.rstrip('\r\n')
	
	# split into index and pronounciation
	lineSplit = line.split('\t')
	process = float(lineNum) / 139986 * 100
	if len(lineSplit) > 1:
		word_ = lineSplit[0]
		pronounciation_ = lineSplit[1]
		pronounciation  = 'silB ' + seperate_phones(pronounciation_) + ' silE'
		
		# if number is included in the word, HTK throws an error.
		if not re.findall('\d', word_) and not re.findall('&', word_) and not re.findall('-', word_) and not re.findall('\'', word_):
			#print '%s\t%s\n' % (word_.upper(), pronounciation)
			print "%d/139986 (%.2f[%%])" % (lineNum, process)
			fout.write('%s\t%s\n' % (word_.upper(), pronounciation))

		
# file close
fout.close()
fin.close()