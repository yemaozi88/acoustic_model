#!/usr/bin/bash
#
# 2017/06/28
#
# Aki Kunikoshi
# 428968@gmail.com
#

## settings
dirMain=/home/Aki/

fileLabel=$dirMain/_same-utterance/eval/script08.list
fileDict=$dirMain/_same-utterance/eval/08.dic

fileLabel_w=$(cygpath -w $fileLabel)
fileDict_w=$(cygpath -w $fileDict)
echo $fileLabel_w
echo $fileDict_w


dirConfig=$dirMain/config
filePhoneList=$dirConfig/phonelist_barbara.txt
filePronDict=$dirConfig/CGN_lexicon_barbara_.txt

filePhoneList_w=$(cygpath -w $filePhoneList)
filePronDict_w=$(cygpath -w $filePronDict)
echo $filePhoneList_w
echo $filePronDict_w

HDMan -m -w $fileLabel_w -n $filePhoneList_w $fileDict_w $filePronDict_w