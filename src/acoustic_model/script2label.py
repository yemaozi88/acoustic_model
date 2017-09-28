#
# 2017/03/30
# convert CGN script to HTK label file.
#
# Aki Kunikoshi
# 428968@gmail.com
#
import sys
import os

# # ../
# print os.path.dirname(sys.path[0])
# # add ../_class
sys.path.append(os.path.join(os.path.dirname(sys.path[0]), '_class'))
import class_convphoneme
i_convphoneme = class_convphoneme.convPhoneme()

args = sys.argv
fileTxt = args[1]
fileLab = args[2]


## open input file
fin  = open(fileTxt, 'r')
line = fin.readline()
line = line.rstrip('\r\n')

## only when following sounds are not included, proceed
if line.find('#') == -1 and line.find('[') == -1 and line.find('-') == -1:
	line_split_cgn = i_convphoneme.split_cgn(line)
	line_split_barbara = i_convphoneme.cgn2barbara(line_split_cgn)
	line_htk = line_split_barbara.replace(' ', '\n')

	## open output file
	fout = open(fileLab, 'w')
	fout.write('ssil\n')
	fout.write("%s\n" % line_htk)
	fout.write('ssil\n')
	fout.close
fin.close
