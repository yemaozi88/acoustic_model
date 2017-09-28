#
# 2017/09/11
#
# make query to union all tables
#
# Aki Kunikoshi
# 428968@gmail.com
#

dirScript = '/home/Aki/_same-utterance/script'
fileIn    = dirScript + '/SentenceList.csv'
fileOut   = dirScript + '/union_query.txt'

## open files
fin  = open(fileIn, 'r')
fout = open(fileOut, 'w')
	
# first two lines are not related to duration
lines = fin.read()
lines = lines.split('\r\n')
lineNumMax = len(lines)

for i in range(1, lineNumMax):
	line_ = lines[i]
	line  = line_.split(',')

	if len(line) > 1:
		id = line[0]
		sentence_id = line[1]
		word_id 	= line[2]
		word 		= line[3]
		field		= line[4]
		if len(sentence_id) == 1:
			sentence_id = '0' + sentence_id

	#print("{0}, {1}, {2}, {3}".format(id, sentence_id, word_id, word))
		fout.write('SELECT filename, region, "{0}" as ID, [{1}].{2} as pronunciation\n'.format(id, sentence_id, field))
		fout.write('FROM [{0}];\n'.format(sentence_id))
		if i != lineNumMax-2:
			fout.write('\nUNION ALL\n\n')

fout.close()
fin.close()