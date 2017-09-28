#!/usr/bin/bash
#
# 2017/07/01
# make pronunciation variance from ipa/cgn transcription.
#
# Aki Kunikoshi
# 428968@gmail.com
#

## ================
## user define
## ================
# home directory
dirHome=/home/Aki/src/forced_alignment

wordlist_ipa=missing_words_ipa.txt
wordlist_cgn=missing_words_cgn.txt
pronvars=missing_words_pronvars.txt
pronvarsHTK=missing_words_pronvarsHTK.txt

# if the input file is written in IPA, uncomment:
#python prondic_ipa2cgn.py $wordlist_ipa $wordlist_cgn

# using barbara's script, make pronunciation variance.
perl pronvars_barbara.perl $wordlist_cgn $pronvars

# convert the obtained pronunciation variance into HTK format.
python pronvar2htk.py $pronvars $pronvarsHTK