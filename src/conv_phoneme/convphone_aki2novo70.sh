#!/usr/bin/bash
#
# 2017/05/07
# script to use convphone_aki2novo70.py
# input file should be given with full path.
#
# Aki Kunikoshi
# 428968@gmail.com
#

## settings
fileLab=$1
convphone_aki2novo70_py=convphone_aki2novo70.py

filename=$(echo $fileLab | sed 's/.lab//g')
fileNovo70=$filename.novo70

python $convphone_aki2novo70_py $fileLab
diff $fileLab $fileNovo70