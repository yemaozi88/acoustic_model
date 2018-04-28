#
# 2017/10/30
# scan the dictionaries.
# if all words are found in the dictionries, do nothing.
# if there are missing words in the dictionaries, 
# execute G2P, and add the pronunciation to the dictionary.
#
# Aki Kunikoshi
# 428968@gmail.compile
#
import sys
import os
import subprocess
import ConfigParser

import numpy as np

## definition
inifile = ConfigParser.SafeConfigParser()
inifile.read('config.ini')
dirDic = inifile.get('make_dic', 'dirDic')
dicList = os.listdir(dirDic)


## get files from the arguments
args = sys.argv
fileLabel = args[1]
# if everything is in the list, filePronvar will not be made.
filePronvar = args[2]
# temporary output file
fileG2P 	 = "fileG2P.txt"
wordlist_cgn = "wordlist_cgn.txt"
pronvars  	 = "pronvars.txt"


## read all words in the input label
fin = open(fileLabel, 'r')
wordlist_ = fin.read()
wordlist  = wordlist_.split('\n')
fin.close()

filePronDict = dicList[0]
for filePronDict in dicList:
	print filePronDict

	## load all items in the pronunciation dictionary
	fin = open(dirDic + '//' + filePronDict, 'r')
	prondict_ = fin.read()
	fin.close()
	
	# get only words
	prondict = prondict_.split('\n')
	prondict = map(lambda x: x.split('\t')[0], prondict)
	
	missing = list(wordlist)
	for word in wordlist:
		if word in prondict:
			missing.remove(word)
	wordlist = list(missing)
	print(wordlist)

if len(wordlist) > 0:
	# make a output file
	fG2P = open(fileG2P, 'w')
	for word in wordlist:
		fG2P.write("%s\n" % word)
	fG2P.close()

	# G2P
	subprocessStr = 'python doG2P.py ' + fileG2P + ' ' + wordlist_cgn
	subprocess.call(subprocessStr, shell=True)
	
	# barbara's code
	#perl pronvars_barbara.perl $wordlist_cgn $pronvars
	subprocessStr = 'perl pronvars_barbara.perl ' + wordlist_cgn + ' ' + pronvars
	subprocess.call(subprocessStr, shell=True)

	# convert the obtained pronunciation variance into HTK format.
	#python pronvar2htk.py $pronvars $pronvarsHTK
	subprocessStr = 'python pronvar2htk.py ' + pronvars + ' ' + filePronvar
	subprocess.call(subprocessStr, shell=True)
	
	os.remove(fileG2P)
	os.remove(wordlist_cgn)
	os.remove(pronvars)