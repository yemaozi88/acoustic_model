#!/usr/bin/bash
#
# 2017/03/20
# train HMM
#
# Aki Kunikoshi
# 428968@gmail.com
#

## settings
dirHome=/net/aistaff/aki
dirFeatureMain=$dirHome/eval
fileScript=$dirHome/config/eval.scp

# for folderletter in b
# do
	# for land in nl vl
	# do
		# folder=comp-$folderletter/$land
		# echo $folder
		# dirFeature=$dirFeatureMain/$folder
		for i in $(ls $dirFeatureMain/*.mfcc) 
		do
			echo $i >> $fileScript
		done # for i
	# done # land
# done # folderletter
