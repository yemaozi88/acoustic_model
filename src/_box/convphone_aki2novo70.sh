#!/usr/bin/bash
#
# 2017/05/01
# convert phone set from Aki's (based on CGI) to David's (novo70).
#
# Aki Kunikoshi
# 428968@gmail.com
#

## settings
dirHome=/home/MWP-WKS023094/test
fileOld=$dirHome/cgn.txt
fileTmp=$dirHome/novo70_tmp.txt
fileNew=$dirHome/novo70.txt

cp $fileOld $fileTmp
function newline_to_0(){
	sed -e ':a' -e 'N' -e '$!ba' -e 's/\n/0/g' novo70_tmp.txt
}
newline_to_0
#grep -l '@' $fileTmp | xargs sed -e 's/@/ax/g' > $fileNew
#cp $fileNew $fileTmp
#grep -l 'C' $fileTmp | xargs sed -e 's/\<C\>/eu/g' > $fileNew
#cp $fileNew $fileTmp
#grep -l 'a' $fileTmp | xargs sed -e 's/\<a\>/aa/g' > $fileNew
#cp $fileNew $fileTmp
#grep -l 'A' $fileTmp | xargs sed -e 's/A\b/a/g'
#sed ':a;N;$!ba;s/\n/ /g'
#cp $fileNew $fileTmp
#grep -l 'A+' $fileTmp | xargs sed -e 's/A+/aw/g' > $fileNew
#cp $fileNew $fileTmp
#grep -l 'A~' $fileTmp | xargs sed -e 's/\<A~/a\>/g' > $fileNew

