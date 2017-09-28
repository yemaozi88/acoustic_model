#coding:utf8
#
# 2017/07/03
# load pronunciation dictionary written in IPA/CGN and convert the pronunciation into barbara format.
#
# Aki Kunikoshi
# 428968@gmail.compile
#
import sys
import os
sys.path.append(os.path.join(os.path.dirname(sys.path[0]), '_class'))
import class_convphoneme
i_convphoneme = class_convphoneme.convPhoneme()
 
# read all lines
args = sys.argv
fileIn  = args[1]
fileOut = args[2]
isIPA   = args[3]

fin = open(fileIn, 'r')
lines_ = fin.read()
fin.close()

# split lines
lines = lines_.split('\n')

# convert from IPA/CGN to barbara
fout = open(fileOut, 'w')
for line in lines:
	line = line.rstrip()
	if line:
		words = line.split('\t')
		word  = words[0]
		
		if isIPA=="1":
			ipa = words[1]
			ipa_split = i_convphoneme.split_ipa(ipa)
			ipa_split = ipa_split.encode('utf-8') # only alphabet
			cgn_split = i_convphoneme.ipa2cgn(ipa_split)
		else:
			cgn = words[1]
			cgn_split = i_convphoneme.split_cgn(cgn)
		
		# convert to Barbara
		#barbara_split = i_convphoneme.cgn2barbara(cgn_split)
		# remove space
		#barbara = barbara_split.replace(" ", "")
		cgn = cgn_split.replace(" ", "")
			
		fout.write("%s\t%s\n" % (word, cgn))

fout.close()