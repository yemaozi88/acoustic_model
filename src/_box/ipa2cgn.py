#coding:utf8
#
# 2017/07/03
# load pronunciation variance and output it in HTK format.
#
# NOTE
# pronunciation variance (.txt) can be made using pronvars_barbara.perl.
#
# Aki Kunikoshi
# 428968@gmail.compile
#
import sys
import os
import class_convphoneme
i_convphoneme = class_convphoneme.convPhoneme()
 
# read all lines
args = sys.argv
fileIn  = args[1]
fileOut = args[2]

fin = open(fileIn, 'r')
lines_ = fin.read()
fin.close()

# split lines
lines = lines_.split('\n')

# convert from IPA to CGN
fout = open(fileOut, 'w')
for line in lines:
	line = line.rstrip()
	if line:
		words = line.split('\t')
		word  = words[0]
		ipa   = words[1]
		ipa_split = i_convphoneme.split_ipa(ipa)
		ipa_split = ipa_split.encode('utf-8') # only alphabet
		cgn_split = i_convphoneme.ipa2cgn(ipa_split)
		# remove space
		cgn_split = cgn_split.replace(" ", "")
		fout.write("%s\t%s\n" % (word, cgn_split))

fout.close()