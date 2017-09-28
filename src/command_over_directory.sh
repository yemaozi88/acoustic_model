#!/usr/bin/bash
#
# 2017/04/02
# split wav files according to the transcription
#
# Aki Kunikoshi
# 428968@gmail.com
#
driveletter=i
for folderletter in a b c d e f g h i j k l m n o
#for folderletter in a
do
	folder=comp-$folderletter
	for land in nl vl
	#for land in nl
	do
		echo $folder/$land

		dirLab=/cygdrive/$driveletter/DutchAcousticModel/wav/$folder/$land
		dirFeature=/cygdrive/$driveletter/DutchAcousticModel/feature/$folder/$land
		dirOut=/cygdrive/$driveletter/DutchAcousticModel/data/$folder/$land
	
		mkdir -p $dirOut

		if [ -e $dirLab ]
		then
			for i in $(find $dirLab/*.lab -type f | sed 's!^.*/!!'); 
			do
				filename=$(echo $i | sed 's/.lab//g')
				cp $dirFeature/$filename.mfc $dirOut/$filename.mfc
				cp $dirLab/$filename.lab $dirOut/$filename.lab
				echo $filename
			done
		fi
	done
done
