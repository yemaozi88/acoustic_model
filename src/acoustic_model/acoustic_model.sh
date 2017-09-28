#!/usr/bin/bash
#
# 2017/03/26
# upzip .fon of CGN
#
# Aki Kunikoshi
# 428968@gmail.com
#
#dirHome=/home/p280427
dirHome=/net/aistaff/aki
dirCGN=/net/corpora/CGN_2.0.3/data
dirFonGzMain=$dirCGN/annot/text/fon
dirWavInMain=$dirCGN/audio/wav

dirFonMain=$dirHome/_cgn/fon
dirOutMain=$dirHome/_cgn/wav_splitted
dirLabMain=$dirHome/_cgn/label/barbara


#for folderletter in a b c d e f g h i j k l m n
for folderletter in o
do
	for land in nl vl
	do		
		folder=comp-$folderletter/$land
		echo $folder

		dirFonGz=$dirFonGzMain/$folder
		dirWavIn=$dirWavInMain/$folder
		
		dirFon=$dirFonMain/$folder
		dirOut=$dirOutMain/$folder
		dirLab=$dirLabMain/$folder
		
		# make directory if not exist
		#mkdir -p $dirFon
		#mkdir -p $dirOut
		#mkdir -p $dirLab
		
		#for i in $(find $dirFonGz/*.fon.gz -type f | sed 's!^.*/!!')
		for i in $(find $dirOut/*.txt -type f | sed 's!^.*/!!')
		#for i in $(ls $dirOut/*.txt)
		do
			filename=$(echo $i | sed 's/.txt//g')
			echo $filename
			fileWav=$dirWavIn/$filename.wav
			fileFon=$dirFon/$filename.fon
			
			fileTxt=$dirOut/$filename.txt
			fileLab=$dirLab/$filename.lab

			# copy the .fon file to local directory
			#cp $dirFonGz/$filename.fon.gz $dirFon
			
			# unzip .fon file
			#gzip -d $dirFon/$filename.fon.gz
			#mv $dirFonGz/$filename.fon $dirFon
			
			# split wav file based on .fon file
			# if [ -e $fileWav ]
			# then
				# python $dirHome/src/acoustic_model/split_wav.py $fileWav $fileFon $dirOut
			# fi
			
			
			## convert script into label files.
			python $dirHome/src/acoustic_model/script2label.py $fileTxt $fileLab
			
		done # i		
	done # land
done # folderletter
