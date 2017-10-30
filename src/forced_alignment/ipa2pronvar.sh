#!/usr/bin/bash
#
# 2017/07/01
# make pronunciation variance from ipa/cgn transcription.
#
# HISTORY
# 2017/10/24 g2p is added.
#
# Aki Kunikoshi
# 428968@gmail.com
#

## ================
## user define
## ================
# home directory
dirHome=/home/Aki/src/forced_alignment

# when manually transcribed (ipa) 
#wordlist_ipa=missing_words_ipa.txt
# when G2P is used
wordlist_man=missing_words_man.lab

wordlist_cgn=missing_words_cgn.txt
pronvars=missing_words_pronvars.txt
pronvarsHTK=missing_words_pronvarsHTK.txt


# if the input file is written in IPA, uncomment:
#python prondic_ipa2cgn.py $wordlist_ipa $wordlist_cgn

# when G2P is used, uncomment
python doG2P.py $wordlist_man $wordlist_cgn

# using barbara's script, make pronunciation variance.
perl pronvars_barbara.perl $wordlist_cgn $pronvars

# convert the obtained pronunciation variance into HTK format.
python pronvar2htk.py $pronvars $pronvarsHTK