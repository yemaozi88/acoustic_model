#
# 2017/07/01
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

sys.path.append(os.path.join(os.path.dirname(sys.path[0]), '_class'))
import class_convphoneme
i_convphoneme = class_convphoneme.convPhoneme()


# read all lines
args = sys.argv
fileIn  = args[1]
fileOut = args[2]

fin = open(fileIn, 'r')
lines_ = fin.read()
fin.close()

# split all text into lines
lines = lines_.split('\n')

# output pronunciation variance in HTK format
fout = open(fileOut, 'w')
for line in lines:
	line = line.rstrip()
	pronvars = line.split('/')
	word = pronvars[0].upper()
	if word:
		for var_num in range(1, len(pronvars)):
			pronvar = pronvars[var_num]
			if pronvar:
				pronvar_split   = i_convphoneme.split_cgn(pronvar)
				pronvar_barbara = i_convphoneme.cgn2barbara(pronvar_split)
				fout.write('%s\tssil %s ssil\n' % (word, pronvar_barbara))

fout.close()