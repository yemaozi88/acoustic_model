#!/usr/bin/bash
#
# 2017/03/26
# upzip .fon of CGN
#
# Aki Kunikoshi
# 428968@gmail.com
#
driveletter=i
#dirMain=/cygdrive/$driveletter/DutchAcousticModel/fon
dirInMain=/net/corpora/CGN_2.0.3/data/annot/text/ort
dirOutMain=/net/aistaff/aki/ort
for folderletter in a b c d e f g h i j k l m n o
#for folderletter in o
do
	for land in nl vl
	do
		folder=comp-$folderletter/$land
		echo $folder
		dirIn=$dirInMain/$folder
		dirOut=$dirOutMain/$folder
		mkdir -p $dirOut
		for i in $(find $dirIn/*.gz -type f | sed 's!^.*/!!') ;
		#for i in $(ls $dirIn/*.gz)
		#for i in $(ls $dirIn/*.fon)
		do
			cp $dirIn/$i $dirOut/
			gzip -d $dirOut/$i
			#tr -d \\r <$i >$ilf
			echo $i
		done #i
	done #land
done #folderletter
