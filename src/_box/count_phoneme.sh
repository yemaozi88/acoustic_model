#!/usr/bin/bash
#
# 2017/03/31
# execute commands/script to all files in a directory
#
# Aki Kunikoshi
# 428968@gmail.com
#

# definition
plosive=('p' 't' 'b' 'd' 'k' 'g')
plosiveNum=(0 0 0 0 0 0)
plosiveNumMax=$(expr ${#plosive[*]} - 1)

fricative=('f' 'v' 's' 'z' 'S' 'Z' 'x' 'G' 'h')
fricativeNum=(0 0 0 0 0 0 0 0 0)
fricativeNumMax=$(expr ${#fricative[*]} - 1)

sonorant=('N' 'm' 'n' 'J' 'l' 'r' 'w' 'j')
sonorantNum=(0 0 0 0 0 0 0 0)
sibirabtNumMax=$(expr ${#sonorant[*]} - 1)

vowel_s=('I' 'E' 'A' 'O' 'Y')
vowel_sNum=(0 0 0 0 0)
vowel_sNumMax=$(expr ${#vowel_s[*]} - 1)

vowel_l=('i' 'y' 'e' '2' 'a' 'o' 'u')
vowel_lNum=(0 0 0 0 0 0 0)
vowel_lNumMax=$(expr ${#vowel_l[*]} - 1)

sjwa=('@' 'sp')
sjwaNum=(0 0)
sjwaNumMax=$(expr ${#sjwa[*]} - 1)

diphthong=('E+' 'Y+' 'A+')
diphthongNum=(0 0 0)
diphthongNumMax=$(expr ${#diphthong[*]} - 1)

leen=('E:' 'Y:' 'O:')
leenNum=(0 0 0)
leenNumMax=$(expr ${#leen[*]} - 1)

nasal=('E~' 'A~' 'O~' 'Y~')
nasalNum=(0 0 0 0)
nasalNumMax=$(expr ${#nasal[*]} - 1)

#dirIn=/home/MWP-WKS023094/src
#fout=$dirIn/phoneCount.txt

#===== CGN =====
driveletter=i
#for folderletter in a b c d e f g h i j k l m n o
for folderletter in a
do
	folder=comp-$folderletter
	for land in nl
	do
		echo $folder/$land
		dirIn=/cygdrive/$driveletter/DutchAcousticModel/wav/$folder/$land
		fout=phoneCount_$folder-$land.txt

		#if [ -e $dirIn ]
		#then
#===== CGN =====

for fin in $(ls $dirIn/*.lab) 
do
	echo $fin


for i in `seq 0 $plosiveNumMax`
do
	lineCount=$(grep --text -c -w ${plosive[$i]} $fin)
#	lineCount=$(grep --text -c -w -r ${plosive[$i]} $dirIn)
	plosiveNum[$i]=$(expr ${plosiveNum[$i]} + $lineCount)
done
echo 'NUMBUR OF PHONEMES' > $fout
echo '< PLOSIVE >' >> $fout
echo ${plosive[*]} >> $fout
echo ${plosiveNum[*]} >> $fout

   
for i in `seq 0 $fricativeNumMax`
do
	lineCount=$(grep --text -c -w ${fricative[$i]} $fin)
	fricativeNum[$i]=$(expr ${fricativeNum[$i]} + $lineCount)
done
echo =================== >> $fout
echo '< FRICATIVE >' >> $fout
echo ${fricative[*]} >> $fout
echo ${fricativeNum[*]} >> $fout


for i in `seq 0 $sonorantNumMax`
do
	lineCount=$(grep --text -c -w ${sonorant[$i]} $fin)
	sonorantNum[$i]=$(expr ${sonorantNum[$i]} + $lineCount)
done
echo =================== >> $fout
echo '< SONORANT >' >> $fout
echo ${sonorant[*]} >> $fout
echo ${sonorantNum[*]} >> $fout


for i in `seq 0 $vowel_sNumMax`
do
	lineCount=$(grep --text -c -w ${vowel_s[$i]} $fin)
	vowel_sNum[$i]=$(expr ${vowel_sNum[$i]} + $lineCount)
done
echo =================== >> $fout
echo '< SHORT VOWEL >' >> $fout
echo ${vowel_s[*]} >> $fout
echo ${vowel_sNum[*]} >> $fout


for i in `seq 0 $vowel_lNumMax`
do
	lineCount=$(grep --text -c -w ${vowel_l[$i]} $fin)
	vowel_lNum[$i]=$(expr ${vowel_lNum[$i]} + $lineCount)
done
echo =================== >> $fout
echo '< LONG VOWEL >' >> $fout
echo ${vowel_l[*]} >> $fout
echo ${vowel_lNum[*]} >> $fout


for i in `seq 0 $sjwaNumMax`
do
	lineCount=$(grep --text -c -w ${sjwa[$i]} $fin)
	sjwaNum[$i]=$(expr ${sjwaNum[$i]} + $lineCount)
done
echo =================== >> $fout
echo '< SJWA >' >> $fout
echo ${sjwa[*]} >> $fout
echo ${sjwaNum[*]} >> $fout


for i in `seq 0 $diphthongNumMax`
do
	lineCount=$(grep --text -c -w ${diphthong[$i]} $fin)
	diphthongNum[$i]=$(expr ${diphthongNum[$i]} + $lineCount)
done
echo =================== >> $fout
echo '< DIPHTHONG >' >> $fout
echo ${diphthong[*]} >> $fout
echo ${diphthongNum[*]} >> $fout


for i in `seq 0 $leenNumMax`
do
	lineCount=$(grep --text -c -w ${leen[$i]} $fin)
	leenNum[$i]=$(expr ${leenNum[$i]} + $lineCount)
done
echo =================== >> $fout
echo '< LEENVOCALEN >' >> $fout
echo ${leen[*]} >> $fout
echo ${leenNum[*]} >> $fout


for i in `seq 0 $nasalNumMax`
do
	lineCount=$(grep --text -c -w ${nasal[$i]} $fin)
	nasalNum[$i]=$(expr ${nasalNum[$i]} + $lineCount)
done
echo =================== >> $fout
echo '< NASAL >' >> $fout
echo ${nasal[*]} >> $fout
echo ${nasalNum[*]} >> $fout

done

#===== CGN =====
		#fi
	done
done
#===== CGN =====