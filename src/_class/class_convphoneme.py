#coding:utf8
#
# 2017/06/12
# class to convert phone set.
#
# functions
# 	- ipa2cgn: convert IPA symbols (splitted) to CGN phonemes. 
# 	- cgn2barbara: convert CGN phonemes (splitted) to Barbara's description.
# 	- split_ipa: split a line by IPA phoens
# 	- split_cgn: split a line by CGN phones
#
# Aki Kunikoshi
# 428968@gmail.com
#

class convPhoneme:
	def __init__(self):
		className = 'convPhoneme'

	# 2017/07/03
	# convert IPA symbols to CGN phonemes. 
	def ipa2cgn(self, line):
		# remove the last space at the end
		line = line.rstrip()
		# split words with space
		phonemes = line.split(' ')
		
		# replace phonemes in CGN with phonemes of Barbara
		#for phoneme in phonemes:
		for i in range (0, len(phonemes)):
			if phonemes[i] == 'ə':
				phonemes[i] = '@'
			elif phonemes[i] == 'ɑ':
				phonemes[i] = 'A'		
			elif phonemes[i] == 'ʌu':
				phonemes[i] = 'A+'
			elif phonemes[i] == 'ɛ':
				phonemes[i] = 'E'		
			elif phonemes[i] == 'ɛi':
				phonemes[i] = 'E+'
				
			elif phonemes[i] == 'øː':
				phonemes[i] = 'C'				
			elif phonemes[i] == 'ɣ':
				phonemes[i] = 'G'
			elif phonemes[i] == 'ɪ':
				phonemes[i] = 'I'		
			elif phonemes[i] == 'ŋ':
				phonemes[i] = 'N'
			elif phonemes[i] == 'ɔ':
				phonemes[i] = 'O'
				
			elif phonemes[i] == 'ʃ':
				phonemes[i] = 'S'
			elif phonemes[i] == 'ʏ':
				phonemes[i] = 'Y'		
			elif phonemes[i] == 'œy':
				phonemes[i] = 'Y+'
			elif phonemes[i] == 'ʒ':
				phonemes[i] = 'Z'
				
			elif phonemes[i] == 'aː':
				phonemes[i] = 'a'				
			elif phonemes[i] == 'eː':
				phonemes[i] = 'e'
			elif phonemes[i] == 'ɦ':
				phonemes[i] = 'h'		
			elif phonemes[i] == 'iː':
				phonemes[i] = 'i'
			elif phonemes[i] == 'oː':
				phonemes[i] = 'o'
				
			elif phonemes[i] == 'ʋ':
				phonemes[i] = 'w'				
			elif phonemes[i] == 'ɛː':
				phonemes[i] = 'E:'
			elif phonemes[i] == 'ɦ':
				phonemes[i] = 'h'		
			elif phonemes[i] == 'iː':
				phonemes[i] = 'i'

			elif phonemes[i] == 'œː':
				phonemes[i] = 'Y:'				
			elif phonemes[i] == 'ɔː':
				phonemes[i] = 'O:'
			elif phonemes[i] == 'ɛ̃ː':
				phonemes[i] = 'E~'		
			elif phonemes[i] == 'ɑ̃ː':
				phonemes[i] = 'A~'
			elif phonemes[i] == 'ɔ̃ː':
				phonemes[i] = 'O~'			
			elif phonemes[i] == 'œ̃':
				phonemes[i] = 'U~'
			
			# Aki added
			elif phonemes[i] == 'ʀ':
				phonemes[i] = 'r'
			elif phonemes[i] == 'ɪː':
				phonemes[i] = 'i'
			elif phonemes[i] == 'ʉ':
				phonemes[i] = 'u'
			elif phonemes[i] == 'ː':
				phonemes[i] = ':'
			
				
		output = ' '.join(phonemes)
		return output				
		
		
	# 2017/06/12
	# convert CGN phonemes to Barbara's description.
	# line should be phone written in CGN phonemes.
	# each phoneme should be splitted using 
	def cgn2barbara(self, line):
		# remove the last space at the end
		line = line.rstrip()
		# split words with space
		phonemes = line.split(' ')
		
		# replace phonemes in CGN with phonemes of Barbara
		#for phoneme in phonemes:
		for i in range (0, len(phonemes)):
			if phonemes[i] == 'C':
				phonemes[i] = 'eu'
			elif phonemes[i] == 'A':
				phonemes[i] = 'ac'
			elif phonemes[i] == 'A+':
				phonemes[i] = 'au'
			elif phonemes[i] == 'A~':
				phonemes[i] = 'a'
			
			elif phonemes[i] == 'E':
				phonemes[i] = 'ec'
			elif phonemes[i] == 'E+':
				phonemes[i] = 'ei'
			elif phonemes[i] == 'E~':
				phonemes[i] = 'ec'
			elif phonemes[i] == 'E:':
				phonemes[i] = 'ec'
				
			elif phonemes[i] == 'G':
				phonemes[i] = 'gc'
				
			elif phonemes[i] == 'I':
				phonemes[i] = 'ic'
				
			elif phonemes[i] == 'N':
				phonemes[i] = 'nc'
				
			elif phonemes[i] == 'O':
				phonemes[i] = 'oc'
			elif phonemes[i] == 'O:':
				phonemes[i] = 'oc'
			elif phonemes[i] == 'O~':
				phonemes[i] = 'oc'

			elif phonemes[i] == 'silB':
				phonemes[i] = 'ssil'
			elif phonemes[i] == 'silE':
				phonemes[i] = 'ssil'
			elif phonemes[i] == 'sp':
				phonemes[i] = 'ssil'
				
			elif phonemes[i] == 'S':
				phonemes[i] = 'sc'
				
			elif phonemes[i] == 'Y':
				phonemes[i] = 'yc'
			elif phonemes[i] == 'Y+':
				phonemes[i] = 'ui'
			elif phonemes[i] == 'Y:':
				phonemes[i] = 'yc'
				
			elif phonemes[i] == 'Z':
				phonemes[i] = 'z'

			elif phonemes[i] == 'U~':
				phonemes[i] = 'yc'
							
		output = ' '.join(phonemes)
		return output


	# 2017/07/03
	# split a line by IPA phones
	# if nasalized sound (such as ɛ̃ː) is included, it will give error.
	def split_ipa(self, line):
		# replace all phones with two characters with a single charactor.
		#line2 = line.encode('utf-8')

		line = line.decode('utf-8')
			
		line = line.replace(u'ʌu', 'B')
		line = line.replace(u'ɛi', 'C')
		line = line.replace(u'œy', 'F')
		
		line = line.replace(u'aː', 'A')
		line = line.replace(u'eː', 'E')
		line = line.replace(u'iː', 'I')
		line = line.replace(u'oː', 'O')
		line = line.replace(u'øː', 'D')		
		
		line = line.replace(u'ɛː', 'G')
		line = line.replace(u'œː', 'H')
		line = line.replace(u'ɔː', 'J')

		line = line.replace(u'ɛ̃ː', 'K')
		line = line.replace(u'ɑ̃ː', 'L')
		line = line.replace(u'ɔ̃ː', 'M')
		line = line.replace(u'œ̃', 'N')

		line = line.replace(u'ɪː', 'P')
		
						
		# replace short pause with X
		line = line.replace(u' ', 'X')	

		# add a space between phones
		lineSeperated = line[0]
		for charNum in range(1, len(line)):
			lineSeperated = lineSeperated + u" " + line[charNum]
		
		# replace back phones with two characters
		lineSeperated = lineSeperated.replace('B', u'ʌu')
		lineSeperated = lineSeperated.replace('C', u'ɛi')
		lineSeperated = lineSeperated.replace('F', u'œy')
		
		lineSeperated = lineSeperated.replace('A', u'aː')
		lineSeperated = lineSeperated.replace('E', u'eː')
		lineSeperated = lineSeperated.replace('I', u'iː')
		lineSeperated = lineSeperated.replace('O', u'oː')
		lineSeperated = lineSeperated.replace('D', u'øː')
		
		lineSeperated = lineSeperated.replace('G', u'ɛː')
		lineSeperated = lineSeperated.replace('H', u'œː')
		lineSeperated = lineSeperated.replace('J', u'ɔː')

		lineSeperated = lineSeperated.replace('K', u'ɛ̃ː')
		lineSeperated = lineSeperated.replace('L', u'ɑ̃ː')
		lineSeperated = lineSeperated.replace('M', u'ɔ̃ː')
		lineSeperated = lineSeperated.replace('N', u'œ̃')

		lineSeperated = lineSeperated.replace('P', u'ɪː')
		
		# short pause
		lineSeperated = lineSeperated.replace('X', 'sp')	
		return lineSeperated

	
	# 2017/07/01
	# split a line by CGN phones
	def split_cgn(self, line):
		#diftong = ['E+', 'Y+', 'A+']
		#leen 	= ['E:', 'Y:', 'O:']
		#nasal 	= ['E~', 'A~', 'O~', 'Y~']

		# replace all phones with two characters with a single charactor.
		line = line.replace('A+', 'B')
		line = line.replace('A~', 'D')
		
		line = line.replace('E+', 'F')
		line = line.replace('E:', 'H')
		line = line.replace('E~', 'J')
		
		line = line.replace('O:', 'K')
		line = line.replace('O~', 'L')
		
		line = line.replace('U~', 'M')
		
		line = line.replace('Y+', 'P')
		line = line.replace('Y:', 'Q')
		
		# replace short pause with X
		line = line.replace(' ', 'X')	
		
		# htk outputs error when a phone starts with number
		line = line.replace('2', 'C') 
		
		# assume *_* as one phone *
		line = line.replace('_', '')
		
		# add a space between phones
		lineSeperated = line[0]
		for charNum in range(1, len(line)):
			lineSeperated = lineSeperated + " " + line[charNum]
		
		# replace back phones with two characters
		lineSeperated = lineSeperated.replace('B', 'A+')
		lineSeperated = lineSeperated.replace('D', 'A~')
		
		lineSeperated = lineSeperated.replace('F', 'E+')
		lineSeperated = lineSeperated.replace('H', 'E:')
		lineSeperated = lineSeperated.replace('J', 'E~')
		
		lineSeperated = lineSeperated.replace('K', 'O:')
		lineSeperated = lineSeperated.replace('L', 'O~')
		
		lineSeperated = lineSeperated.replace('M', 'U~')
		
		lineSeperated = lineSeperated.replace('P', 'Y+')
		lineSeperated = lineSeperated.replace('Q', 'Y:')
		
		# short pause
		lineSeperated = lineSeperated.replace('X', 'sp')	
		
		return lineSeperated
