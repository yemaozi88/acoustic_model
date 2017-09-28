#
# 2017/05/01
# convert phone set from CGN to David's (novo70).
#
# NOTE
# - 2 is replaced with C for HTK.
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
while text.count('\n@\n') > 0:
	text = text.replace('\n@\n', '\nax\n')
while text.count('\nC\n') > 0:
	text = text.replace('\nC\n', '\neu\n')
while text.count('\na\n') > 0:
	text = text.replace('\na\n', '\naa\n')
while text.count('\nA\n') > 0:
	text = text.replace('\nA\n', '\na\n')
while text.count('\nA+\n') > 0:
	text = text.replace('\nA+\n', '\naw\n')
while text.count('\nA~\n') > 0:
	text = text.replace('\nA~\n', '\na\n')

while text.count('\nE\n') > 0:
	text = text.replace('\nE\n', '\neh\n')
while text.count('\nE+\n') > 0:
	text = text.replace('\nE+\n', '\nei\n')
while text.count('\nE~\n') > 0:
	text = text.replace('\nE~\n', '\neh\n')
while text.count('\nE:\n') > 0:
	text = text.replace('\nE:\n', '\neh\n')
while text.count('\ne\n') > 0:
	text = text.replace('\ne\n', '\ney\n')

while text.count('\nG\n') > 0:	
	text = text.replace('\nG\n', '\nx\n')

while text.count('\ni\n') > 0:
	text = text.replace('\ni\n', '\niy\n')
while text.count('\nI\n') > 0:
	text = text.replace('\nI\n', '\nih\n')

while text.count('\ny\n') > 0:	
	text = text.replace('\ny\n', '\nuu\n') # j->y, y->uu
while text.count('\nj\n') > 0:
	text = text.replace('\nj\n', '\ny\n')

while text.count('\nN\n') > 0:
	text = text.replace('\nN\n', '\nng\n')

while text.count('\no\n') > 0:	
	text = text.replace('\no\n', '\now\n')
while text.count('\nO\n') > 0:
	text = text.replace('\nO\n', '\noh\n')
while text.count('\nO:\n') > 0:
	text = text.replace('\nO:\n', '\noh\n')
while text.count('\nO~\n') > 0:
	text = text.replace('\nO~\n', '\noh\n')

while text.count('\nS\n') > 0:	
	text = text.replace('\nS\n', '\nsh\n')
	
while text.count('\nu\n') > 0:
	text = text.replace('\nu\n', '\nuw\n')

while text.count('\nY\n') > 0:
	text = text.replace('\nY\n', '\nuh\n')
while text.count('\nY+\n') > 0:
	text = text.replace('\nY+\n', '\nuy\n')
while text.count('\nY:\n') > 0:
	text = text.replace('\nY:\n', '\nuh\n')

while text.count('\nw\n') > 0:
	text = text.replace('\nw\n', '\nwv\n')

while text.count('\nZ\n') > 0:	
	text = text.replace('\nZ\n', '\nzh\n')

while text.count('\nU~\n') > 0:	
	text = text.replace('\nU~\n', '\nuh\n')
	
#	textAfter = text
#	i += 1

# remove the first and the last space
text = text.lstrip('\n')
text = text.rstrip('\n')


# write
fout = open(fileOut, 'w')
fout.write(text)
fout.close()