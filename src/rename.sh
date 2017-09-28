#!/usr/bin/bash
#
# 2017/05/04
# rename files in a directory
#
# Aki Kunikoshi
# 428968@gmail.com
#

## settings
dirHome=/net/aistaff/aki
dirMain=$dirHome/feature

for folderletter in o
do
	for land in vl
	do
		folder=comp-$folderletter/$land
		dirIn=$dirMain/$folder
		echo $dirIn

		for i in $(find $dirIn/*.novo70 -type f | sed 's!^.*/!!')
		do
			filename=$(echo $i | sed 's/.novo70//g')
			fileSource=$dirIn/$filename.novo70
			fileTarget=$dirIn/$filename.lab
			mv $fileSource $fileTarget
		done # i
	done # land
done # folderletter




