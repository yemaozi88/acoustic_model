#!/usr/bin/bash
#
# 2017/06/19
# forced alignment
#
# Aki Kunikoshi
# 428968@gmail.com
#

## ================
## user define
## ================

## sorce directory where forced_alignment.sh is located.
dirSrc=/net/aistaff/aki/src/forced_alignment

## files which should be prepared
# -- local --
#userName=MWP-WKS023094
#dirMain=/home/$userName
#dirIn=/home/$userName/material/same-utterance
#dirOut=/home/$userName/src/forced_alignment
# -- titan --
dirIn=/net/aistaff/aki/_same-utterance
dirOut=/net/aistaff/aki/_same-utterance/forced_alignment

# text file in which the orthographycal transcription of the utterance is written in one line.
finTxt=$dirIn/script/script01.txt

# wav file in which the utterance was recorded.
finWav=$dirIn/wav/01/Groningen_and_Drenthe/28-1449002700-1825.wav

## files which will be made during the forced alignment process

# label file: the list of words that appears in the wave file.
#	should be in the same folder where wav file is stored.
foutLab=$(echo $finWav | sed 's/\.wav/\.lab/g')

# dic file: the pronunciation dictionary in which pronunciation(s) of each word in the label file are described.
#	if you want to change the file extension of dict file (.dic)
# 	please check step 2/4 below. 
foutDic=$dirOut/28-1449002700-1825.dic

# the result of Forced Alignment
# 	*_. txt: the first one is the raw output of HTK which is writtne in 100ns unit (this file will be removed at the end of the script).
# 	*.txt: the second one is written in msec unit.
foutFA_=$dirOut/28-1449002700-1825_.txt
foutFA=$dirOut/28-1449002700-1825.txt


# if this script is excuted on cygwin...
#finWav_w=$(cygpath -w $finWav)
#foutLab_w=$(cygpath -w $foutLab)
#foutDic_w=$(cygpath -w $foutDic)
#foutFA__w=$(cygpath -w $foutFA_) 


## ================
## forced alignment process
## ================
echo "------------------------"
echo ">>>>> step 1/4: load the orthographical transcription and output that word by word (e.g. one word per line) in capital letters..."
python $dirSrc/make_label.py $finTxt $foutLab
echo "------------------------"

echo ">>>>> step 2/4: for each words in the label file pronunciation(s) are searched in the dictionary..."
#python $dirSrc/scan_dic.py $foutLab $foutDicSub
python $dirSrc/make_dic.py $foutLab $foutDic

fError=$(echo $foutDic | sed 's/\.dic/\.log/g')
if [ -e $fError ]; then
    echo "!!!!! cannot proceed to forced alignment."
	echo "!!!!! the label file includes unknown words."
	echo "!!!!! please check $fError."
	echo "!!!!! and add their pronunciation to the extra pronunciation dictionary."
	echo "!!!!! extra pronunciation dictionary:  /net/aistaff/aki/config/CGN_lexicon_barbara_extra.txt"
else
	echo "------------------------"

	echo ">>>>> step 3/4: forced alignment..."
	#python forced_alignment.py $finWav_w $foutLab_w $foutDic_w $foutFA__w
	python $dirSrc/forced_alignment.py $finWav $foutLab $foutDic $foutFA_
	echo "------------------------"

	echo ">>>>> step 4/4: convert 100ns unig to ms in HTK forced alignment output..." 
	python $dirSrc/100ns2ms.py $foutFA_ $foutFA
	rm -rf $foutFA_
	echo "$foutFA_ is removed."
	echo "------------------------"

	echo "Forced Alignment completed."
fi
