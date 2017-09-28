#
# 2017/06/12
# load transcript and output in capital letters.
#
# Aki Kunikoshi
# 428968@gmail.compile
#
import sys
import os


# read all lines
args = sys.argv
fileIn  = args[1]
fileOut = args[2]

fin = open(fileIn, 'r')
lines_ = fin.read()
fin.close()

# split lines
lines = lines_.split('\n')

# forcus on only the first line
line1 = lines[0]

# remove space at the end and comma
line1 = line1.rstrip()
line1 = line1.replace(',', '')

# write each word in a capital letter 
line1list = line1.split(' ')
fout = open(fileOut, 'w')
for word in line1list:
	#print word.upper()
	fout.write("%s\n" % word.upper())
fout.close()