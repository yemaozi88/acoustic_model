#!/usr/bin/bash
#
# 2017/07/30
# forced alignment for all files in a folder
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
dirIn=/net/aistaff/aki/_same-utterance

for script_num in 01 02 03 04 05 06 07 08 09 10
#for script_num in 01
do
for region in Groningen_and_Drenthe Limburg Oost_Overijsel-Gelderland
#for region in Groningen_and_Drenthe
do
	# text file in which the orthographycal transcription of the utterance is written in one line.
	finTxt=$dirIn/script/script$script_num.txt

	# wav file in which the utterance was recorded.
	dirWav=$dirIn/wav/$script_num/$region
	dirOut=$dirWav

	for i in $(find $dirWav/*.wav -type f | sed 's!^.*/!!');
	do
		filename=$(echo $i | sed 's/.wav//g')
		echo script$script_num:$region - $filename
		
		finWav=$dirWav/$filename.wav
		
		## files which will be made during the forced alignment process
		foutLab=$(echo $finWav | sed 's/\.wav/\.lab/g')
		foutDic=$dirOut/$filename.dic
		foutFA_=$dirOut/$filename_.txt
		foutFA=$dirOut/$filename.txt
		foutLog=$dirOut/$filename.log
		foutTG=$dirOut/$filename.fon
		
		
		## ================
		## forced alignment process
		## ================
		#echo "------------------------"
		#echo ">>>>> step 1/4: load the orthographical transcription and output that word by word (e.g. one word per line) in capital letters..."
		python $dirSrc/make_label.py $finTxt $foutLab
		#echo "------------------------"

		#echo ">>>>> step 2/4: for each words in the label file pronunciation(s) are searched in the dictionary..."
		python $dirSrc/make_dic.py $foutLab $foutDic
		fError=$(echo $foutDic | sed 's/\.dic/\.log/g')
		if [ -e $fError ]; then
			echo "!!!!! cannot proceed to forced alignment."
			echo "!!!!! the label file includes unknown words."
			echo "!!!!! please check $fError."
			echo "!!!!! and add their pronunciation to the extra pronunciation dictionary."
			echo "!!!!! extra pronunciation dictionary:  /net/aistaff/aki/config/CGN_lexicon_barbara_extra.txt"
		else
			#echo "------------------------"

			#echo ">>>>> step 3/4: forced alignment..."
			#python forced_alignment.py $finWav_w $foutLab_w $foutDic_w $foutFA__w
			python $dirSrc/forced_alignment.py $finWav $foutLab $foutDic $foutFA_ >& $foutLog
			#echo "------------------------"

			#echo ">>>>> step 4/4: convert 100ns unig to ms in HTK forced alignment output..." 
			python $dirSrc/100ns2ms.py $foutFA_ $foutFA
			rm -rf $foutFA_
			#echo "$foutFA_ is removed."
			#echo "------------------------"

			# make TextGrid
			python fa2fon.py $foutFA $foutTG
			#echo "Forced Alignment completed."
		fi
	done
done
done
