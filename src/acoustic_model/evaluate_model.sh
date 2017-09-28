#!/usr/bin/bash
#
# 2017/03/24
# recognition and evaluation of the model.
#
# Aki Kunikoshi
# 428968@gmail.com
#

## definition
dirMain=/home/Aki
dirIn=$dirMain/_same-utterance
#dirFeature=$dirIn/feature/digit
dirFeature=$dirIn/eval/08

dirConfig=$dirMain/config
fileConfig=$dirConfig/config.rec
filePhoneList=$dirConfig/phonelist_barbara.txt

# word network file can be made using HParse
#fileWordNetwork=$dirConfig/digit2.ltc
fileWordNetwork=$dirIn/eval/08.ltc
#filePhoneDictionary=$dirConfig/digit2.phone.dic
filePhoneDictionary=$dirIn/eval/08.dic

fileScript_HVite=$dirMain/script/HVite.scp
fileScript_HResults=$dirMain/script/HResults.scp
fileLabel=$dirConfig/eval.mlf

hmmdefsName=hmmdefs.compo
#dirModel0=$dirIn/model/hmm0
dirModelN=$dirMain/model/barbara/hmm2-2


#dirWav_win=$(cygpath -w $dirWav)
dirFeature_win=$(cygpath -w $dirFeature)
dirConfig_win=$(cygpath -w $dirConfig)
fileConfig_win=$(cygpath -w $fileConfig)
filePhoneList_win=$(cygpath -w $filePhoneList)
fileWordNetwork_win=$(cygpath -w $fileWordNetwork)
filePhoneDictionary_win=$(cygpath -w $filePhoneDictionary)

fileScript_HVite_win=$(cygpath -w $fileScript_HVite)
fileScript_HResults_win=$(cygpath -w $fileScript_HResults)
#dirModel0_win=$(cygpath -w $dirModel0)
dirModelN_win=$(cygpath -w $dirModelN)


#fileProto_win=$(cygpath -w $fileProto)
#plMkhmmdefs_win=$(cygpath -w $pl_mkhmmdefs)
#filePhoneList_win=$(cygpath -w $filePhoneList)
fileLabel_win=$(cygpath -w $fileLabel)

## make a list of feature files.
# if there is already a script file, delete it. 
if [ -e $fileScript_HVite ]
then
	rm $fileScript_HVite
fi
for i in $(find $dirFeature/*.mfc -type f | sed 's!^.*/!!'); do
    echo "$dirFeature_win\\$i" >> $fileScript_HVite
done

# recognition
HVite -T 1 -C $fileConfig_win -w $fileWordNetwork_win -H $dirModelN_win\\$hmmdefsName $filePhoneDictionary_win $filePhoneList_win -S $fileScript_HVite_win


## make a list of feature files.
# if there is already a script file, delete it. 
if [ -e $fileScript_HResults ]
then
	rm $fileScript_HResults
fi
for i in $(find $dirFeature/*.rec -type f | sed 's!^.*/!!'); do
    echo "$dirFeature_win\\$i" >> $fileScript_HResults
done

# evaluation
HResults -t -T 1 -I $fileLabel_win $filePhoneList_win -S $fileScript_HResults_win