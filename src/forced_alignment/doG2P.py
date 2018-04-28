#
# 2017/10/24
# process to get pronunciation variation for unknown words
# - perform g2p program of Gosse
# - convert each pronunciation into Barbara's description
# - perform Barbara's perl script
#
# Aki Kunikoshi
# 428968@gmail.compile
#
import sys
import os
import subprocess

sys.path.append(os.path.join(os.path.dirname(sys.path[0]), '_class'))
import class_convphoneme
i_convphoneme = class_convphoneme.convPhoneme()

args = sys.argv
fileLabel 	 = args[1]
fileLabelNew = args[2]
g2pIn  = 'g2pIn.txt'
g2pOut = 'g2pOut.txt'

## label file should be written in:
# - small capital
# - EOF should be LF
windows_line_ending = '\r\n'
linux_line_ending = '\n'
with open(fileLabel, 'rb') as f:
    content = f.read()
    content = content.replace(windows_line_ending, linux_line_ending)
with open(g2pIn, 'wb') as f:
    f.write(content.lower())

	
## g2p
subprocessStr = './string2phon < ' + g2pIn + ' > ' + g2pOut
subprocess.call(subprocessStr, shell=True)


## format output
with open(g2pIn, 'r') as f:
	word = f.read()
with open(g2pOut, 'r') as f:
	pron = f.read()
os.remove(g2pIn)
os.remove(g2pOut)

wordList = word.split('\n')
pronList = pron.split('\n')

fout = open(fileLabelNew, 'w')
for i in range(0, len(wordList)):
	wordOut = wordList[i].upper()
	
	# convert from CGN to barbara
	#pronOut = i_convphoneme.split_cgn(pronList[i])
	#pronOut = i_convphoneme.cgn2barbara(pronOut)
	#pronOut = pronOut.replace(' ', '')
	pronOut = pronList[i]
	
	fout.write("{0}\t{1}\n".format(wordOut, pronOut))