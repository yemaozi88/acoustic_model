#
# 2017/09/25
# select samples from the combined.csv for the further analysis
#
# Aki Kunikoshi
# 428968@gmail.com
#

import ConfigParser

inifile = ConfigParser.SafeConfigParser()
inifile.read('./config.ini')
dirMain = inifile.get('select_samples', 'dirMain')
fileWordList = dirMain + '/' + inifile.get('select_samples', 'fileWordList')
fileCombined = dirMain + '/' + inifile.get('select_samples', 'fileCombined')
fileOut = dirMain + '/num.csv'


## load wordlist	
fin = open(fileWordList, 'r')
lines = fin.read()
fin.close()

fout = open(fileOut, 'w')
wordList = lines.split('\r\n')
for wordNum in range(1, 95): # number on csv file
	word = wordList[wordNum-1] # target word
	#print("=== {} ===".format(word))


	## load combined data 
	fin = open(fileCombined, 'r')
	line = fin.readline()

	listGroningen = []
	listLimburg   = []
	listOverijsel = []
	while line:
		line = fin.readline()
		line = line.rstrip()
		lineList = line.split(',')
		if len(lineList) == 6 and lineList[5] == word:
			region = lineList[2]
			if region == 'Groningen_and_Drenthe':
				listGroningen.append(lineList)
			elif region == 'Limburg':
				listLimburg.append(lineList)
			elif region == 'Oost_Overijsel-Gelderland':
				listOverijsel.append(lineList)
	fin.close()

	print("{0}: {1} {2} {3}".format(word,len(listGroningen),len(listLimburg),len(listOverijsel)))
	fout.write("{0},{1},{2},{3}\n".format(word,len(listGroningen),len(listLimburg),len(listOverijsel)))

fout.close()