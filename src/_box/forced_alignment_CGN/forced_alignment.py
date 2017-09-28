#
# 2017/04/10
#
# Aki Kunikoshi
# 428968@gmail.com
#
import sys
import os
import subprocess

#args = sys.argv
#fileWav = args[1]
#fileLab = args[2]
#fileOut = args[3]

fileWav = "fn001001_0-000.wav"
fileLab = "fn001001_0-000.lab"
fileOut = "fn001001_0-000.out"

## default settings
#dirMain = "/net/aistaff/aki"
#dirMain = "/home/MWP-WKS023094"
dirMain = "/home/A.Kunikoshi"
dirMain_w = "C:\cygwin64\home\A.Kunikoshi"
dirMainSub_w = dirMain_w + "\\src_local\\forced_alignment"

#fileConfig    = dirMain + "/config/config.HVite"
#filePhoneList = dirMain + "/config/monophone.list"
#fileHMMdefs   = dirMain + "/model/hmm32-4/hmmdefs.compo"
fileConfig_w = dirMain_w + "\\config\\config.HVite"
filePhoneList_w = dirMain_w + "\\config\\monophone.list"
fileHMMdefs_w = dirMainSub_w + "\\monophone.list"


## files to prepare
fileMlf = fileWav.replace('.wav', '.mlf')
fileScp = fileWav.replace('.wav', '.scp')
fileDic = fileWav.replace('.wav', '.dic')


## script
#fout = open(fileScp, 'w')
#fout.write("./" + fileWav)
#fout.close()

## master label file
print fileLab
fin = open(fileLab, 'r')
allLine = fin.read()
fin.close()
fout = open(fileMlf, 'w')
fout.write("#!MLF!#\n")
fout.write('"./' + fileLab + '"\n')
fout.write(allLine)
fout.close()

## dictionary file
fin = open(fileLab, 'r')
fout = open(fileDic, 'w')
line = fin.readline()
line = line.rstrip('\r\n')
while line:
	fout.write(line + '\t' + line + '\n')
	line = fin.readline()
	line = line.rstrip('\r\n')
fout.close()
fin.close()

## forced alignment
#subprocessStr = 'HVite -T 1 -a -m -C ' + fileConfig + ' -H ' + fileHMMdefs + ' -m -I ' + fileMlf + ' -i ' + fileOut + ' -S ' + fileScp + ' ' + fileDic + ' ' + filePhoneList
# windows version

fileWav_w = dirMainSub_w + '\\' + fileWav
fileLab_w = dirMainSub_w + '\\' + fileLab
fileOut_w = dirMainSub_w + '\\' + fileOut
fileMlf_w = fileWav_w.replace('.wav', '.mlf')
fileScp_w = fileWav_w.replace('.wav', '.scp')
fileDic_w = fileWav_w.replace('.wav', '.dic')
subprocessStr = 'HVite -T 1 -a -m -C ' + fileConfig_w + ' -H ' + fileHMMdefs_w + ' -m -I ' + fileMlf_w + ' -i ' + fileOut_w + ' -S ' + fileScp_w + ' ' + fileDic_w + ' ' + filePhoneList_w

subprocess.call(subprocessStr, shell=True)
#print subprocessStr

#os.remove(fileScp)
#os.remove(fileMlf)
#os.remove(fileDic)