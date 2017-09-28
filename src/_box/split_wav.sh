#!/usr/bin/bash
#
# 2017/03/31
# split wav files according to the transcription
# you need to change fon or ort depends on the file extension.
#
# Aki Kunikoshi
# 428968@gmail.com
#

#driveletter=i
dirMain=/net/aistaff/aki/fon

for folderletter in a b c d e f g h i j k l m n o
#for folderletter in o
do
	for land in nl vl
	do
		folder=comp-$folderletter/$land

		#dirWav=/cygdrive/$driveletter/_data/data/audio/wav/$folder/$land
		#dirFon=/cygdrive/$driveletter/DutchAcousticModel/fon/$folder/$land
		
		dirOut=$dirMain/$folder
	
		mkdir -p $dirOut

		#if [ -e $dirWav ]
		#then
			for i in $(find $dirOut/*.fon -type f | sed 's!^.*/!!'); 
			do
				filename=$(echo $i | sed 's/.fon//g')
				#fileWav=$dirWav/$filename.wav
				#fileFon=$dirFon/$filename.fon
				fileIn=$dirOut/$filename.fon
				fileOut=$dirOut/$filename.txt
		
				#if [ -e $fileFon ]
				#then
				#	python split_wav.py $fileWav $fileFon $dirOut
				#fi
				python list_sentence.py $fileIn $fileOut
				echo $filename
			done
		#fi
	done
done
