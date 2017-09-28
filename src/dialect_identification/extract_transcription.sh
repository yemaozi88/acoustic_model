#!/usr/bin/bash
#
# 2017/07/31
#
# Aki Kunikoshi
# 428968@gmail.com
#

## ================
## user define
## ================

## sorce directory where sorce files are located.
dirSrc=/home/Aki/src/dialect_identification

## files which should be prepared
dirIn=/home/Aki/_same-utterance

for script_num in 01 02 03 04 05 06 07 08 09 10
do
#for region in Groningen_and_Drenthe Limburg Oost_Overijsel-Gelderland
#do
	# # wav file in which the utterance was recorded.
	# dirWav=$dirIn/wav/$script_num/$region
	# dirOut=$dirWav
	
	# # extract transcription
	# for i in $(find $dirWav/*.txt -type f | sed 's!^.*/!!');
	# do
		# filename=$(echo $i | sed 's/.txt//g')
		# echo $script_num:$region - $filename
		
		# fin=$dirWav/$filename.txt
		# fout=$dirWav/$filename.out
		# python $dirSrc/extract_transcription.py $fin $fout
		# echo $region >> $fout
	# done
	
	# combine the extracted transcription
	#echo $dirOut
	cat $dirIn/wav/$script_num/*/*.out > $dirIn/wav/$script_num/$script_num.csv
	#rm -rf $dirWav/*.out
#done # region
done # script_num
