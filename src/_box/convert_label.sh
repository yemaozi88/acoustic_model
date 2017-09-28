#!/usr/bin/bash
#
# 2017/03/31
# execute commands/script to all files in a directory
#
# Aki Kunikoshi
# 428968@gmail.com
#
dirHome=/net/aistaff/aki

for folderletter in a b c d e f g h i j k l m n o
#for folderletter in a
do
	folder=comp-$folderletter
	for land in nl vl
	do
		dirIn=/cygdrive/$driveletter/DutchAcousticModel/wav/$folder/$land
		if [ -e $dirIn ]
		then
			#for i in $(find $dirIn/*.txt -type f | sed 's!^.*/!!'); 
			for i in $(find $dirIn/*.txt)
			do
				echo $i
				python convert_label.py $i
			done
		fi
	done
done
