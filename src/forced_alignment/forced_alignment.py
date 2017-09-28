#
# 2017/04/10
# forced alignment using HTK.
#
# INPUT
#  	wav file: wav file in which the utterance was recorded
# 	label file: the list of words that appears in the wave file.
#		should be in the same folder where wav file is stored.
# 	dic file: the pronunciation dictionary in which pronunciation(s) of each word in the label file are described.
# OUTPUT
#  the result of Forced Alignment in txt file format.
# 
# HISTORY
# 2017/06/27 clean up the code.
# 2017/06/14 some variables are loaded from .ini file.  
#
# Aki Kunikoshi
# 428968@gmail.com
#
import sys
import os
import subprocess
import ConfigParser

iscygwin = 1


## load arguments
args = sys.argv
fileWav_ = args[1]
fileLab_ = args[2]
fileDic_ = args[3]
fileOut_ = args[4]

if iscygwin:
	fileWav = fileWav_.replace('\\', '\\\\')
	fileLab = fileLab_.replace('\\', '\\\\')
	fileDic = fileDic_.replace('\\', '\\\\')
	fileOut = fileOut_.replace('\\', '\\\\')
else:
	fileWav = fileWav_
	fileLab = fileLab_
	fileDic = fileDic_
	fileOut = fileOut_

	
## load the ini file
inifile = ConfigParser.SafeConfigParser()
inifile.read('./config.ini')
fileConfig = inifile.get('forced_alignment', 'fileConfig')
filePhoneList = inifile.get('forced_alignment', 'filePhoneList')
fileHMMdefs = inifile.get('forced_alignment', 'fileHMMdefs')

	
## files for forced alignment (automatically made)
fileMlf = fileWav.replace('.wav', '.mlf')
fileScp = fileWav.replace('.wav', '.scp')
#fileDic = fileWav.replace('.wav', '.dic')


## script
fout = open(fileScp, 'w')
fout.write(fileWav_)
fout.close()


## master label file
fin = open(fileLab, 'r')
allLine = fin.read()
fin.close()
fout = open(fileMlf, 'w')
fout.write("#!MLF!#\n")
fout.write('"' + fileLab + '"\n')
fout.write(allLine)
fout.close()


## dictionary file for phone recognition
#fin = open(fileLab, 'r')
#fout = open(fileDic, 'w')
#line = fin.readline()
#line = line.rstrip('\r\n')
#while line:
#	fout.write(line + '\t' + line + '\n')
#	line = fin.readline()
#	line = line.rstrip('\r\n')
#fout.close()
#fin.close()


## forced alignment
subprocessStr = 'HVite -T 1 -a -C ' + fileConfig + ' -H ' + fileHMMdefs + ' -m -I ' + fileMlf + ' -i ' + fileOut + ' -S ' + fileScp + ' ' + fileDic + ' ' + filePhoneList

subprocess.call(subprocessStr, shell=True)
#print subprocessStr


## terminate process
os.remove(fileScp)
os.remove(fileMlf)
#os.remove(fileDic)