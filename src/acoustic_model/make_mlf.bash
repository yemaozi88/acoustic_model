#!/usr/bin/bash
#
# 2017/04/02
# make MasterLabelFile for train_model.sh.
#
# Aki Kunikoshi
# 428968@gmail.com
#
#fileMLF=/net/aistaff/aki/config/train.mlf
dirMain=/home/Aki
fileMLF=$dirMain/config/eval.mlf
echo "#!MLF!#" > $fileMLF

#dirLab=/net/aistaff/aki/_cgn/label/barbara/comp-o/nl
dirLab=$dirMain/_same-utterance/eval/08
fileLabOriginal=$dirMain/_same-utterance/script/script08.list
for i in $(find $dirLab/*.wav -type f | sed 's!^.*/!!')
do
	filename=$(echo $i | sed 's/.wav//g')
	echo $filename
	fileLab=$dirLab/$filename.lab
	cp $fileLabOriginal $fileLab
	#echo "\"$dirLab/$filename.lab\"" >> $fileMLF
	echo "\"$fileLab\"" >> $fileMLF
	#cat $dirLab/$filename.lab >> $fileMLF
	cat $fileLab >> $fileMLF
	echo "." >> $fileMLF
done
