#!/usr/bin/bash
#
# 2017/03/20
# train HMM
#
# Aki Kunikoshi
# 428968@gmail.com
#

## extract MFCC from wav files
#dirMain=/home/A.Kunikoshi
#dirMain=/home/MWP-WKS023094
dirMain=/net/aistaff/aki
dirFeature=$dirMain/_cgn/feature/comp-o/nl
dirConfig=$dirMain/config
fileConfig=$dirConfig/config.train
fileScript=$dirMain/script/HCompV.scp
dirModel=$dirMain/model/barbara
dirModel0=$dirModel/hmm0
protoName=proto38
fileProto=$dirModel/$protoName
plMkhmmdefs=$dirMain/src/acoustic_model/mkhmmdefs.pl
filePhoneList=$dirConfig/phonelist_barbara.txt
fileMasterLabel=$dirConfig/train.mlf
hmmdefsName=hmmdefs.compo

## convert path to windows format
# dirFeature_win=$(cygpath -w $dirFeature)
# dirConfig_win=$(cygpath -w $dirConfig)
# fileConfig_win=$(cygpath -w $fileConfig)
# fileScript_win=$(cygpath -w $fileScript)
# dirModel0_win=$(cygpath -w $dirModel0)
# fileProto_win=$(cygpath -w $fileProto)
# filePhoneList_win=$(cygpath -w $filePhoneList)
# fileMasterLabel_win=$(cygpath -w $fileMasterLabel)


## make a list of feature files.
# if there is already a script file, delete it. 
#if [ -e $fileScript ]
#then
#	rm $fileScript
#fi
#for i in $(find $dirFeature/*.mfc -type f | sed 's!^.*/!!'); do
#    echo "$dirFeature/$i" >> $fileScript
#done


## flat start
#mkdir -p $dirModel0
#HCompV -T 1 -C $fileConfig_win -m -v 0.01 -S $fileScript_win -M $dirModel0_win $fileProto_win
#HCompV -T 1 -C $fileConfig -m -v 0.01 -S $fileScript -M $dirModel0 $fileProto
# allocate mean & variance to all phones in the phone list
#perl $plMkhmmdefs $dirModel0/$protoName $filePhoneList > $dirModel0/$hmmdefsName


## The flat start monophones stored in the directory hmm0 are re-estimated.
#pruning -t 250.0 150.0 1000.0 ?
iterNumMax=2
for mixNum in 1 2 4 8 16 32 64 128
do
	for iterNum in $(seq 1 $iterNumMax)
	do
		echo ======= mix$mixNum - $iterNum =======
		mixNum_pre=$[ $mixNum / 2 ]
		iterNum_pre=$[ $iterNum - 1]
		dirModelN=$dirModel/hmm$mixNum-$iterNum
		#dirModelN_win=$(cygpath -w $dirModelN)
		if [ $iterNum -eq 1 ] && [ $mixNum -eq 1 ]
		then
			dirModelN_pre=$dirModel/hmm0
		else
			dirModelN_pre=$dirModel/hmm$mixNum-$iterNum_pre
		fi
		#dirModelN_pre_win=$(cygpath -w $dirModelN_pre)
		
		## re-estimation
		mkdir -p $dirModelN
		#HERest -T 1 -C $fileConfig_win -v 0.01 -I $fileMasterLabel_win -H $dirModelN_pre_win\\$hmmdefsName -M $dirModelN_win $filePhoneList_win -S $fileScript_win
		HERest -T 1 -C $fileConfig -v 0.01 -I $fileMasterLabel -H $dirModelN_pre/$hmmdefsName -M $dirModelN $filePhoneList -S $fileScript

	done # iterNum
	mixNum_pro=$[ $mixNum * 2 ]
	dirModelN_pro=$dirModel/hmm$mixNum_pro-0
	#dirModelN_pro_win=$(cygpath -w $dirModelN_pro)
	mkdir $dirModelN_pro
	
	fileHeader=$dirModelN/mix$mixNum_pro.hed
	fileHeader_win=$(cygpath -w $fileHeader)

	echo MU $mixNum_pro {*.state[2-4].mix} > $fileHeader
	#HHEd -T 1 -H $dirModelN_win\\$hmmdefsName -M $dirModelN_pro_win $fileHeader_win $filePhoneList_win
	HHEd -T 1 -H $dirModelN/$hmmdefsName -M $dirModelN_pro $fileHeader $filePhoneList
done # mixNum
