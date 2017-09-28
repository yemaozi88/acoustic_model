#!/usr/bin/bash
#
# 2017/03/20
# small adjustment to the data
#
# Aki Kunikoshi
# 428968@gmail.com
#

## settings
dirHome=/net/aistaff/aki
#dirFeatureMain=$dirHome/feature
#dirLabelMain=$dirHome/label/cgn
#fileScript=$dirHome/config/train.scp

#dirFeature=$dirFeatureMain/comp-o/nl


#for folderletter in o
#do
	for land in nl vl
	do
#		folder=comp-$folderletter/$land
		#dirFeature=$dirFeatureMain/$folder
		dirIn=$dirHome/label/cgn/comp-o/$land
		dirOut=$dirHome/label/barbara/comp-o/$land
		#echo $folder
		
		for i in $(find $dirIn/*.lab -type f | sed 's!^.*/!!')
		do
			#filename=$(echo $i | sed 's/.lab//g')
			#fileOld=$dirFeature/$filename.lab
			#echo $fileOld
			#fileNew=$dirFeature/$filename.lab2
			#grep -l '2' $fileOld | xargs sed -e 's/2/C/g' > $fileNew
			#grep -l ' ' $fileOld | xargs sed -e 's/ //g' > $fileNew
			#if [ -s $fileNew ]
			#then
			#	cp $fileNew $fileOld
			#fi
			#rm $fileNew

			fileIn=$dirIn/$i
			fileOut=$dirOut/$i
			echo $i
			python conv_cgn2barbara.py $fileIn $fileOut
			#rm $fileLab
			#cd mv $fileNovo70 $fileLab
		done #i
		
	done # land
#done # folderletter




