#
# 2017/06/12
# (1) make dic file using the CGN_NL_dictionary.
# (2) convert it to Barbara's description.
# (3) make pronunciation variant.
#
# HISTORY: 
# 2017/06/19
# (1) and (2) are removed. because Aki couldn't make barbara's perl script work, the words are picked up from the dictionary using HDMan.
# 2017/10/24 for unknown words, g2p is executed instead of throwing an error.
#
# Aki Kunikoshi
# 428968@gmail.compile
#
import sys
import os
import subprocess
import ConfigParser

#import class_convphoneme
#i_convphoneme = class_convphoneme.convPhoneme()

## definition
inifile = ConfigParser.SafeConfigParser()
inifile.read('./config.ini')
filePronDict = inifile.get('make_dic', 'filePronDict')
#filePronDictManual = inifile.get('make_dic', 'filePronDictManual')
#filePronDictG2P = inifile.get('make_dic', 'filePronDictG2P')
dirG2P = inifile.get('make_dic', 'dirG2P')


## read all lines
args = sys.argv
fileLabel = args[1]
fileDict = args[2]
path, ext = os.path.splitext(fileDict)
fileError = fileDict.replace(ext, ".log")


# =============================
# (1) make dic file using the CGN_NL_dictionary.
# =============================
#dirConfig = "/home/Aki/config"
#filePronDict = dirConfig + "/CGN_lexicon_CGN"
#filePhoneList = dirConfig + "/phonelist_barbara.txt"

#filePronDict_w = dirMain_w + "\\\config\\\CGN_NL_dictionary.txt"
#filePhoneList_w = dirMain_w + "\\\config\\\monophone_barbara\\\monophone.list"
#filePronDict_w = dirMain_w + "\\\config\\\CGN_NL_dictionary_barbara.txt"
# fileProto_win=$(cygpath -w $fileProto)

#subprocessStr = 'HDMan -m -w ' + fileLabel + ' -n ' + filePhoneList_w + ' ' + fileDict + ' ' + filePronDict_w
#print subprocessStrscript
#subprocess.call(subprocessStr, shell=True)


# =============================
# (2) convert it to Barbara's description.
# =============================
# fin = open(fileDict, 'r')
# lines = fin.read()
# fin.close()

# # split lines
# fout = open(fileOutB, 'w')
# lines = lines.split('\n')
# for line in lines:
	# line = line.rstrip()
	# pStart = line.find('silB')
	# pEnd = len(line)
	# if pStart > 0:
		# pronunciation = line[pStart:pEnd]
		# pronunciation_b = i_convphoneme.cgn2barbara(pronunciation)
		# words = line.split(' ')
		# fout.write("%s\t%s\n" % (words[0].lower(), pronunciation_b))
# fout.close()


# =============================
# (3) make pronunciation variant.
# =============================
fin = open(fileLabel, 'r')
wordlist_ = fin.read()
wordlist  = wordlist_.split('\n')
fin.close()

fin = open(filePronDict, 'r')
lines_ = fin.read()
lines  = lines_.split('\n')
fin.close()


fout = open(fileDict, 'w')
ferr = open(fileError, 'w')
for word in wordlist:
	if word != "": 
		if lines_.find('\n' + word + '\t') == -1:
			#print ">>>>> word %s cannot be found in the dictionary." % word
			fout.write(">>>>> word %s cannot be found in the dictionary.\n" % word)
			ferr.write("%s\t\n" % word)
			
			## unknown words will be written in 
			
		else:
			for line in lines:
				# remove space at the end, comma
				line = line.rstrip()
				linelist = line.split('\t')
				index = linelist[0]
				index = index.rstrip()
				if index == word:
					#print "%s\t%s" % (index, linelist[1])
					fout.write("%s\t%s\n" % (index, linelist[1]))
fout.close()
ferr.close()

# when no error, the log file will be removed.
if os.path.getsize(fileError) == 0:
	os.remove(fileError)