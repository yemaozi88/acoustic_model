#!/usr/bin/bash
#
# 2017/03/16
# extract feature from wav files.
#
# Aki Kunikoshi
# 428968@gmail.com
#

## settings
#dirHome=/net/aistaff/aki
dirHome=/home/Aki
fileConfig=$dirHome/config/config.HCopy
fileScript=$dirHome/script/HCopy.scp
#dirWavMain=$dirHome/_cgn/wav_splitted
#dirLabMain=$dirHome/_cgn/label/barbara
#dirOutMain=$dirHome/_cgn/feature

dirWav=$dirHome/_same-utterance/eval/08
dirOut=$dirWav

fileConfig_win=$(cygpath -w $fileConfig);
fileScript_win=$(cygpath -w $fileScript);
dirWav_win=$(cygpath -w $dirWav);
dirOut_win=$(cygpath -w $dirOut);

# if there is already a script file, delete it. 
echo ">>>>> making a script file for HCopy..."
if [ -e $fileScript ]
then
	rm $fileScript
fi


#===== CGN =====
#for folderletter in a b c d e f g h i j k l m n
# do
	# for land in nl vl
	# do		
		# folder=comp-$folderletter/$land
		# echo $folder
		
		# dirWav=$dirWavMain/$folder
		# dirLab=$dirLabMain/$folder
		# dirOut=$dirOutMain/$folder
		# mkdir -p $dirOut
#===== CGN =====


# make a script file for HCopy
for i in $(find $dirWav/*.wav -type f | sed 's!^.*/!!'); 
do
	filename=$(echo $i | sed 's/.wav//g')
	#echo $folder - $i
	#echo $filename
	
	#cp $dirWav/$filename.lab $dirOut/$filename.lab
    echo "$dirWav_win\\$filename.wav	$dirOut_win\\$filename.mfc" >> $fileScript
	#echo "$dirWav/$filename.wav	$dirOut/$filename.mfc" >> $fileScript
done


#===== CGN =====
#	done # land
#done # folderletter
#===== CGN =====


echo ">>>>> extracting features..."
#HCopy -C $fileConfig -S $fileScript
HCopy -C $fileConfig_win -S $fileScript_win
