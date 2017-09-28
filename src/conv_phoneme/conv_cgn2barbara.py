#
# 2017/05/29
# convert phone set from Aki's (based on CGN) to David's (novo70).
#
# NOTE
# - 2 is replaced with C for HTK in CGN.
#
# Aki Kunikoshi
# 428968@gmail.com
#

import sys
import os

args = sys.argv

#fileIn = 'cgn.txt'
#fileOut = 'novo70.txt'
fileIn  = args[1]
fileOut = args[2]

## output file names
#dirIn = os.path.dirname(fileLab)
#finBaseExt = os.path.basename(fileLab)
#finBase = finBaseExt.replace('.lab', '')
#finName  = dirIn + '/' + finBase + '.lab' 
#foutName = dirIn + '/' + finBase + '.novo70'
#print finName

# read the file
fin  = open(fileIn, 'r')
text = fin.read()
fin.close()


# add space before and after the text.
text  = '\n' + text + '\n'
#textBefore = 'before'
#textAfter  = 'after'
#i = 1

# somewhat when the same charater appears multipletimes in a row
# only the first one is replaced.
#while textBefore != textAfter:
	
#	print i
#	textBefore = text
	
# convert each phone
while text.count('\nC\n') > 0:
	text = text.replace('\nC\n', '\neu\n')
	
while text.count('\nA\n') > 0:
	text = text.replace('\nA\n', '\nac\n')
while text.count('\nA+\n') > 0:
	text = text.replace('\nA+\n', '\nau\n')
while text.count('\nA~\n') > 0:
	text = text.replace('\nA~\n', '\na\n')

	
while text.count('\nE\n') > 0:
	text = text.replace('\nE\n', '\nec\n')
while text.count('\nE+\n') > 0:
	text = text.replace('\nE+\n', '\nei\n')
while text.count('\nE~\n') > 0:
	text = text.replace('\nE~\n', '\nec\n')
while text.count('\nE:\n') > 0:
	text = text.replace('\nE:\n', '\nec\n')	
	
while text.count('\nG\n') > 0:
	text = text.replace('\nG\n', '\ngc\n')
	
while text.count('\nI\n') > 0:
	text = text.replace('\nI\n', '\nic\n')
	
while text.count('\nN\n') > 0:
	text = text.replace('\nN\n', '\nnc\n')
	
while text.count('\nO\n') > 0:
	text = text.replace('\nO\n', '\noc\n')
while text.count('\nO:\n') > 0:
	text = text.replace('\nO:\n', '\noc\n')
while text.count('\nO~\n') > 0:
	text = text.replace('\nO~\n', '\noc\n')

while text.count('\nsilB\n') > 0:
	text = text.replace('\nsilB\n', '\nssil\n')
while text.count('\nsilE\n') > 0:
	text = text.replace('\nsilE\n', '\nssil\n')	
		
while text.count('\nS\n') > 0:	
	text = text.replace('\nS\n', '\nsc\n')
	
while text.count('\nY\n') > 0:
	text = text.replace('\nY\n', '\nyc\n')	
while text.count('\nY+\n') > 0:
	text = text.replace('\nY+\n', '\nui\n')
while text.count('\nY:\n') > 0:
	text = text.replace('\nY:\n', '\nyc\n')

while text.count('\nZ\n') > 0:
	text = text.replace('\nZ\n', '\nz\n')
	
while text.count('\nU~\n') > 0:	
	text = text.replace('\nU~\n', '\nyc\n')


# remove the first and the last space
text = text.lstrip('\n')
text = text.rstrip('\n')


# write
fout = open(fileOut, 'w')
fout.write(text)
fout.close()