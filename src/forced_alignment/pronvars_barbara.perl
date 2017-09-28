#! /usr/bin/perl -w

#Generate pronunciation variants 
#This script produces overgeneralized pronunciation variants. All knowledge based rules are applied also on all produced pronunciation variants.
#input: canonical lexicon (TST lexicon), includes already final-n deletion rule;
#change input-path in line 10, output-path in line 201; 
#Author: Barbara Schuppler, Oct. 2010

# HISTORY
# 2017/07/01 
# - the input and output is changed to be taken from arguments. 
# - renamed the code from 2017_1303_generate_pronvars.perl to pronvars_barbara.perl.
# Aki Kunikoshi (428968@gmail.com)
#
#________________________________________________________________________________________________________________________

#load the canonical lexicon
#$lexicon_canonical = "pronvars.txt";   #change here path to canonical lexicon in .txt format
$lexicon_canonical = $ARGV[0];

open(LEXICON, "$lexicon_canonical");
@lexicon = <LEXICON>;
close (LEXICON);

#______________________________________________________________________________________________________
#first we need to reconstruct the final-n-deletion that was already implemented in the TST lexicon
$howoften1ruleW = 0;
@where=();
for ($j= 0; $j <= $#lexicon; $j++)
{
	$orthography = "";
	$canonical = "";
	chomp $lexicon[$j];
	@input = split (/\s+/, $lexicon[$j]);
	$orthography = $input[0];
	$canonical = $input[1];

	$newpron1count = 0;
	if($orthography =~ /en$/ || $orthography =~ /ën$/)
	{
		$canonical =~ s/\@$/\@n/g;

		$howoften1ruleW = $howoften1ruleW + 1;
	}

	$canonical=~ s/b-'([dg])/p-'$1/g;		#repair anticipatory assimilation	
	$canonical=~ s/d-'([bg])/t-'$1/g;
	$canonical=~ s/g-'([bd])/k-'$1/g;
	$canonical=~ s/v-'([bdg])/f-'$1/g;
	$canonical=~ s/z-'([bdg])/s-'$1/g;
	$canonical=~ s/Z-'([bdg])/S-'$1/g;
	$canonical=~ s/G-'([bdg])/x-'$1/g;

	$canonical=~ s/b-([dg])/p-$1/g;		
	$canonical=~ s/d-([bg])/t-$1/g;
	$canonical=~ s/g-([bd])/x-$1/g;
	$canonical=~ s/v-([bdg])/f-$1/g;
	$canonical=~ s/z-([bdg])/s-$1/g;
	$canonical=~ s/Z-([bdg])/S-$1/g;
	$canonical=~ s/G-([bdg])/x-$1/g;

	$canonical=~ s/b([dg])/p$1/g;		
	$canonical=~ s/d([bg])/t$1/g;
	$canonical=~ s/g([bd])/k$1/g;
	$canonical=~ s/v([bdg])/f$1/g;
	$canonical=~ s/z([bdg])/s$1/g;
	$canonical=~ s/Z([bdg])/S$1/g;
	$canonical=~ s/G([bdg])/x$1/g;
	$lexicon[$j]= $orthography."/".$canonical;
	$where[$j]= $orthography."/".$canonical;	
}
print "total final_n_completion: $howoften1ruleW\n";
#________________________________________________________________________________________________________


#this array will be used to call all the subroutines that contain the reduction rules:
@reductionrules= ('habsence_hebben', 'ndelition_afterschwa', 'anticipatiory_assimilation', 'intervocalic_obstruents','voiced_to_unvoiced_consonants', 'fricatives_devoiced', ,'ndelition_betweenvowel_ands',  'longtoshortvowels', 'delof_bilabialplosives_afterm', 'consonant_in_ncluster','rdeletion_after_lowvowels', 'rdeletion_after_schwa','shortvowels', 'shortvowels_between_vn',  'voweltoschwas_limited', 'schwadelition_limited', 'lijkreduction', 'tdelition_in_sclusters', 'tdelition_in_consonantclusters', 'tdeletion_in_finalposition', 'tdeletion_before_plosives','same_articulation_place', 'nog_toch','carryover_assimilation_plosives', 'initial_fricative');

@howoften1rule= ();				#in this array, each entry says how often a certain rule was applied on the lexicon
for($i=0; $i<=($#reductionrules+1); $i++)    	#+1 because &extreme_reduced_words also write in this array but not element 
{					   	#of @reductionrules
	$howoften1rule[$i]=0;
}



for($i=0; $i<=$#lexicon; $i++)
#for($i=0; $i<=1; $i++)
{
	chomp $lexicon[$i];
	$countwhichrule = 0;
	foreach $sub(@reductionrules)
	{
#print "this is the sub variable $sub and its numbering $countwhichrule\n";
		@pronvars = split(/\//, $lexicon[$i]);
		for($pv=1; $pv<=$#pronvars; $pv++)			#starts at 1 because first element is orthography
		{
			#call function on that variant and add a new variant to the lexicon
			$pronvar = $pronvars[$pv];
			&$sub;
		}
		$countwhichrule++;
	}
}
@howoften = keys (%H_newpron1count);
for ($h=0; $h <=$#howoften; $h++)
{
print "$howoften[$h]\n";	
}
#_____________________________________________________________________________________________________________________


#add extremely reduced variants and also the variants for highly frequentfunction words
$howoftenextreme=0;
$howoftenfunctionword=0;

for($i=0; $i<=$#lexicon; $i++)
{
	chomp $lexicon[$i];
	@pronvars = split(/\//, $lexicon[$i]);
	&extreme_reduced_words($pronvars[0]);			
	&function_words($pronvars[0], $pronvars[1]);
	&schwainsertion($pronvars[1]);

}
print "Extreme reduced forms: $howoftenextreme\n";
print "function words: $howoftenfunctionword\n";
#_________________________________________________________________________________________________________________



#check for same pronunciationvariants generated in different stages of the script
for($h=0; $h<=$#lexicon; $h++)
{
	chomp $lexicon[$h];
	@parts = ();
	@parts = split (/\//, $lexicon[$h]);
	for ($p = 1; $p <=$#parts; $p++)
	{
		chomp $parts[$p];
		$w= &degemination($parts[$p]);
		$parts[$p]=$w;
		$parts[$p]=~ s/-+/-/g;
		$parts[$p]=~ s/^'-/'/g;
		$parts[$p]=~ s/^-//g;
		$parts[$p]=~ s/-$//g;
		$parts[$p]=~ s/^-'/'/g;
		

		$parts[$p]=~ s/([IEAOYiye2aou\@])-+\1/$1/g;		#merge 'E+-G@-@k to 'E+-G@k: one syllable if same vowel
		$parts[$p]=~ s/([IEAOYiye2aou\@])-+'+\1/$1/g; 		#then this whole syllable carries the stress??

		if ($parts[$p] =~ m/[pbtdkgfvszSZxGh]-*'*[pbtdkgfvszSZxGh]-*'*[pbtdkgfvszSZxGh]-*'*[pbtdkgfvszSZxGh]/)	
		{
			$parts[$p]= "";
		}
	}
		
	$lexicon[$h]= join("/", @parts);
	$lexicon[$h] =~ s/\/{2,}/\//g;
	@parts = split (/\//, $lexicon[$h]);
	#search for same pronvars
	for($j=1; $j< 2; $j++)						#first check if there are same as canonical
	{
		$forcomparison = $parts[$j];
		$forcomparison =~ s/'+//g;				#sometimes we generate same pronvariants but with the
		$forcomparison =~ s/-+//g;				#syllable boundaries somewhere else

		for($i=($j+1); $i<= $#parts; $i++)
		{
			chomp $parts[$i];
			$forcomparison2 = $parts[$i];
			$forcomparison2 =~ s/'+//g;
			$forcomparison2 =~ s/-+//g;
			if($forcomparison2 eq $forcomparison)
			{
				$parts[$i]= "SAME";
			}
		}	
	}
	for($j=2; $j< $#parts; $j++)
	{
		$forcomparison = $parts[$j];
		$forcomparison =~ s/'+//g;				#sometimes we generate same pronvariants but with the
		$forcomparison =~ s/-+//g;				#syllable boundaries somewhere else

		for($i=($j+1); $i<= $#parts; $i++)
		{
			chomp $parts[$i];
			$forcomparison2 = $parts[$i];
			$forcomparison2 =~ s/'+//g;
			$forcomparison2 =~ s/-+//g;
			if($forcomparison2 eq $forcomparison)
			{
				$parts[$i]= "SAME";
				#last;
			}
		}	
	}
	$lexicon[$h]= join("/", @parts);
	$lexicon[$h]=~ s/SAME//g;
	$lexicon[$h] =~ s/\/{2,}/\//g;
}
#________________________________________________________________________________________________________________


#calculate average pronvar per word and max pronvarnumber
&calculate_average_NR_pronvars;		


#open(LEXICONWITHPRONVAR, ">.../2014_0606_dict_pronvars.txt");
open(LEXICONWITHPRONVAR, "> $ARGV[1]");

for($i=0; $i<=$#lexicon; $i++)
{
	print LEXICONWITHPRONVAR "$lexicon[$i]\n";
}
close (LEXICONWITHPRONVAR);


#_________________________________________________________________________________________________________________________
#__________________________________________________________________________________________________end main programm








sub calculate_average_NR_pronvars
{
	$numberofpronvar= 0;
	for ($j= 0; $j <= $#lexicon; $j++)
	{
		chomp $lexicon[$j];
		@parts = ();
		@parts = split (/\//, $lexicon[$j]);
		$numberofpronvar = $numberofpronvar + ($#parts);
		$H_maxpronvar{$#parts}++;


		#for calculating average number of pronunciation variants depending on the syllable number
		#@syllables = split(/-/, $parts[1]);
		#$numberofsyllables = $#syllables+1;
		
	}

	@nrpronvar = keys (%H_maxpronvar);
	@nrpronvarfrequ = values (%H_maxpronvar);
	$average = $numberofpronvar/($#lexicon+1);
	print "average number of pronunciation variants = $average \n";
	#open(NRPRONVAR, ">/S2S/schuppler/1stPaper/Lexicon/exclME/PronVars/20090623_NR_pronvars.txt");
	$average2 =0;
	$collect = 0;
	$collect2 = 0;
	for ($j= 0; $j <= $#nrpronvar; $j++)
	{
		#print NRPRONVAR "$nrpronvar[$j]\t$nrpronvarfrequ[$j]\n";
		if ($nrpronvar[$j] > 80)
		{
		 	$collect= $collect + $nrpronvar[$j]*$nrpronvarfrequ[$j];
			$collect2= $collect2 + $nrpronvarfrequ[$j];		
		}
	}
	$average2 = ($numberofpronvar-$collect)/(($#lexicon+1)-$collect2);
	print "average number of pronunciation variants >80 = $average2 \n";
	#close(NRPRONVAR);
}
#________________________________________________________________________________________________


sub ndelition_afterschwa
{
	$newpron= $pronvar;	
	$newpron=~ s/\@n-/\@-/g;
	$newpron=~ s/\@n$/\@/g;
	if ($newpron ne $pronvar)
	{
		$lexicon[$i] = $lexicon[$i]."/".$newpron;
		$where[$i]= $where[$i]."/".$newpron.$countwhichrule;	
		$howoften1rule[$countwhichrule] = $howoften1rule[$countwhichrule]+1;
	}	
}
#________________________________________________________________________________________________


sub schwainsertion
{
	$pronvar = $_[0];
	$newpron= $pronvar;	
	$newpron=~ s/l([fmxkp])$/l-\@$1/g;
	$newpron=~ s/r([fmxk])$/r-\@$1/g;
	if ($newpron ne $pronvar)
	{
		$lexicon[$i] = $lexicon[$i]."/".$newpron;
		$where[$i]= $where[$i]."/".$newpron.$countwhichrule;	
		$howoften1rule[$countwhichrule] = $howoften1rule[$countwhichrule]+1;
	}	
}
#_________________________________________________________________________________________________
sub intervocalic_obstruents
{
	$newpron= $pronvar;	
	$newpron=~ s/([AEIOYaeiouy2\@])p-([AEIOYaeiouy2\@])/$1b-$2/g;
	$newpron=~ s/([AEIOYaeiouy2\@])t-([AEIOYaeiouy2\@])/$1d-$2/g;
	$newpron=~ s/([AEIOYaeiouy2\@])x-([AEIOYaeiouy2\@])/$1G-$2/g;
	$newpron=~ s/([AEIOYaeiouy2\@])k-([AEIOYaeiouy2\@])/$1g-$2/g;
	$newpron=~ s/([AEIOYaeiouy2\@])f-([AEIOYaeiouy2\@])/$1v-$2/g;
	$newpron=~ s/([AEIOYaeiouy2\@])s-([AEIOYaeiouy2\@])/$1z-$2/g;
	$newpron=~ s/([AEIOYaeiouy2\@])S-([AEIOYaeiouy2\@])/$1Z-$2/g;

	$newpron=~ s/([AEIOYaeiouy2\@])p-'([AEIOYaeiouy2\@])/$1b-'$2/g;
	$newpron=~ s/([AEIOYaeiouy2\@])t-'([AEIOYaeiouy2\@])/$1d-'$2/g;
	$newpron=~ s/([AEIOYaeiouy2\@])x-'([AEIOYaeiouy2\@])/$1G-'$2/g;
	$newpron=~ s/([AEIOYaeiouy2\@])k-'([AEIOYaeiouy2\@])/$1g-'$2/g;
	$newpron=~ s/([AEIOYaeiouy2\@])f-'([AEIOYaeiouy2\@])/$1v-'$2/g;
	$newpron=~ s/([AEIOYaeiouy2\@])s-'([AEIOYaeiouy2\@])/$1z-'$2/g;
	$newpron=~ s/([AEIOYaeiouy2\@])S-'([AEIOYaeiouy2\@])/$1Z-'$2/g;

	$newpron=~ s/([AEIOYaeiouy2\@])-p([AEIOYaeiouy2\@])/$1-b$2/g;
	$newpron=~ s/([AEIOYaeiouy2\@])-t([AEIOYaeiouy2\@])/$1-d$2/g;
	$newpron=~ s/([AEIOYaeiouy2\@])-x([AEIOYaeiouy2\@])/$1-G$2/g;
	$newpron=~ s/([AEIOYaeiouy2\@])-k([AEIOYaeiouy2\@])/$1-g$2/g;
	$newpron=~ s/([AEIOYaeiouy2\@])-f([AEIOYaeiouy2\@])/$1-v$2/g;
	$newpron=~ s/([AEIOYaeiouy2\@])-s([AEIOYaeiouy2\@])/$1-z$2/g;
	$newpron=~ s/([AEIOYaeiouy2\@])-S([AEIOYaeiouy2\@])/$1-Z$2/g;

	$newpron=~ s/([AEIOYaeiouy2\@])-'p([AEIOYaeiouy2\@])/$1-'b$2/g;
	$newpron=~ s/([AEIOYaeiouy2\@])-'t([AEIOYaeiouy2\@])/$1-'d$2/g;
	$newpron=~ s/([AEIOYaeiouy2\@])-'x([AEIOYaeiouy2\@])/$1-'G$2/g;
	$newpron=~ s/([AEIOYaeiouy2\@])-'k([AEIOYaeiouy2\@])/$1-'g$2/g;
	$newpron=~ s/([AEIOYaeiouy2\@])-'f([AEIOYaeiouy2\@])/$1-'v$2/g;
	$newpron=~ s/([AEIOYaeiouy2\@])-'s([AEIOYaeiouy2\@])/$1-'z$2/g;
	$newpron=~ s/([AEIOYaeiouy2\@])-'S([AEIOYaeiouy2\@])/$1-'Z$2/g;
	if ($newpron ne $pronvar)
	{
		$lexicon[$i] = $lexicon[$i]."/".$newpron;
		$where[$i]= $where[$i]."/".$newpron.$countwhichrule;	
		$howoften1rule[$countwhichrule] = $howoften1rule[$countwhichrule] + 1;
	}	
}
#______________________________________________________________________________________________________
sub carryover_assimilation_plosives		# plosives are unvoiced if preceded by a unvoiced plosive
{
	$newpron= $pronvar;	
	$newpron=~ s/([tk])-b/$1-p/g;	
	$newpron=~ s/([pk])-d/$1-t/g;
	$newpron=~ s/([tpk])-g/$1-k/g;	

	$newpron=~ s/([tk])-'b/$1-'p/g;	
	$newpron=~ s/([pk])-'d/$1-'t/g;
	$newpron=~ s/([tpk])-'g/$1-'k/g;	
	
	if ($newpron ne $pronvar)
	{
		$lexicon[$i] = $lexicon[$i]."/".$newpron;
		$where[$i]= $where[$i]."/".$newpron.$countwhichrule;	
		$howoften1rule[$countwhichrule] = $howoften1rule[$countwhichrule] + 1;
	}	
}
#______________________________________________________________________________________________________
sub anticipatiory_assimilation		# obstruents are voiced if followed by a voiced plosive
{
	$newpron= $pronvar;	
	$newpron=~ s/p-'([dg])/b-'$1/g;		
	$newpron=~ s/t-'([bg])/d-'$1/g;
	$newpron=~ s/k-'([bd])/g-'$1/g;
	$newpron=~ s/f-'([bdg])/v-'$1/g;
	$newpron=~ s/s-'([bdg])/z-'$1/g;
	$newpron=~ s/S-'([bdg])/Z-'$1/g;
	$newpron=~ s/x-'([bdg])/G-'$1/g;

	$newpron=~ s/p-([dg])/b-$1/g;		
	$newpron=~ s/t-([bg])/d-$1/g;
	$newpron=~ s/k-([bd])/g-$1/g;
	$newpron=~ s/f-([bdg])/v-$1/g;
	$newpron=~ s/s-([bdg])/z-$1/g;
	$newpron=~ s/S-([bdg])/Z-$1/g;
	$newpron=~ s/x-([bdg])/G-$1/g;

	$newpron=~ s/p([dg])/b$1/g;		
	$newpron=~ s/t([bg])/d$1/g;
	$newpron=~ s/k([bd])/g$1/g;
	$newpron=~ s/f([bdg])/v$1/g;
	$newpron=~ s/s([bdg])/z$1/g;
	$newpron=~ s/S([bdg])/Z$1/g;
	$newpron=~ s/x([bdg])/G$1/g;

	if ($newpron ne $pronvar)
	{
		$lexicon[$i] = $lexicon[$i]."/".$newpron;
		$where[$i]= $where[$i]."/".$newpron.$countwhichrule;	
		$howoften1rule[$countwhichrule] = $howoften1rule[$countwhichrule] + 1;
	}	
}
#______________________________________________________________________________________________________
sub same_articulation_place
{
	$newpron= $pronvar;	
	$newpron=~ s/([bp])([AEIOYaeiouy2\@])-'([bp])/'$3/g;
	$newpron=~ s/([td])([AEIOYaeiouy2\@])-'([td])/'$3/g;
	$newpron=~ s/([kg])([AEIOYaeiouy2\@])-'([kg])/'$3/g;
	$newpron=~ s/([vf])([AEIOYaeiouy2\@])-'([vf])/'$3/g;
	$newpron=~ s/([sz])([AEIOYaeiouy2\@])-'([zs])/'$3/g;
	$newpron=~ s/([Gx])([AEIOYaeiouy2\@])-'([Gx])/'$3/g;
	if ($newpron ne $pronvar)
	{
		$lexicon[$i] = $lexicon[$i]."/".$newpron;
		$where[$i]= $where[$i]."/".$newpron.$countwhichrule;	
		$howoften1rule[$countwhichrule] = $howoften1rule[$countwhichrule] + 1;
	}	
}
#_______________________________________________________________________________________________________
sub nog_toch
{
	$newpron= $pronvar;	
	$newpron=~ s/^'nOx$/'nO/g;
	$newpron=~ s/^'tOx$/'tO/g;

	if ($newpron ne $pronvar)
	{
		$lexicon[$i] = $lexicon[$i]."/".$newpron;
		$where[$i]= $where[$i]."/".$newpron.$countwhichrule;	
		$howoften1rule[$countwhichrule] = $howoften1rule[$countwhichrule] + 1;
	}	
}
#_________________________________________________________________________________________________________
sub initialb_asm
{
	$newpron= $pronvar;	
	$newpron=~ s/^'be/'me/;
	$newpron=~ s/^'bE/'mE/;
	$newpron=~ s/^'b\@/'m\@/;
	$newpron=~ s/^be/me/;
	$newpron=~ s/^bE/mE/;
	$newpron=~ s/^b\@/m\@/;
	if ($newpron ne $pronvar)
	{
		$lexicon[$i] = $lexicon[$i]."/".$newpron;
		$where[$i]= $where[$i]."/".$newpron.$countwhichrule;	
		$howoften1rule[$countwhichrule] = $howoften1rule[$countwhichrule] + 1;
	}	
}
#______________________________________________________________________________________________________
sub fricatives_devoiced
{
	$newpron= $pronvar;	
	$newpron=~ s/v/f/g;
	$newpron=~ s/z/s/g;
	$newpron=~ s/Z/S/g;
	$newpron=~ s/G/x/g;
	if ($newpron ne $pronvar)
	{
		$lexicon[$i] = $lexicon[$i]."/".$newpron;
		$where[$i]= $where[$i]."/".$newpron.$countwhichrule;	
		$howoften1rule[$countwhichrule] = $howoften1rule[$countwhichrule] + 1;
	}	
}

sub initial_fricative
{
	$newpron= $pronvar;	
	$newpron=~ s/^f/v/g;
	$newpron=~ s/^s/z/g;
	$newpron=~ s/^S/Z/g;
	$newpron=~ s/^x/G/g;
	if ($newpron ne $pronvar)
	{
		$lexicon[$i] = $lexicon[$i]."/".$newpron;
		$where[$i]= $where[$i]."/".$newpron.$countwhichrule;	
		$howoften1rule[$countwhichrule] = $howoften1rule[$countwhichrule] + 1;
	}	
}
#______________________________________________________________________________________________________
sub ndelition_befores
{
	$newpron= $pronvar;	
	$newpron=~ s/([AEIOYaeiouy2\@])ns/$1s/g;
	$newpron=~ s/([AEIOYaeiouy2\@])n-s/$1-s/g;
	$newpron=~ s/([AEIOYaeiouy2\@])n-'s/$1-'s/g;
	if ($newpron ne $pronvar)
	{
		$lexicon[$i] = $lexicon[$i]."/".$newpron;
		$where[$i]= $where[$i]."/".$newpron.$countwhichrule;	
		$howoften1rule[$countwhichrule] = $howoften1rule[$countwhichrule] + 1;
	}	
}
#______________________________________________________________________________________________________
sub longtoshortvowels
{
	@newpron1 = (); 
	$newpron = "";
	@syllables = split (/-/, $pronvar);
	$newpron1count = 0;
	for ($s= 0; $s <= $#syllables; $s++)
	{
		if ($syllables[$s] =~ /'/)			
		{
			$newpron1[$s] = $syllables[$s];
		}
		else
		{
			$newpron1[$s]= $syllables[$s];	
			$newpron1[$s]=~ s/a/A/;
			$newpron1[$s]=~ s/e/I/;
			$newpron1[$s]=~ s/o/O/;
			$newpron1[$s] =~ s/y/Y/;

			if ($newpron1[$s] ne $syllables[$s])
			{
				$newpron1count = 1;
			}		
		}
	}
	if ($newpron1count == 1)
	{
		$howoften1rule[$countwhichrule] = $howoften1rule[$countwhichrule] + 1;
		$newpron = $newpron1[0];
		for($g = 1; $g <=$#syllables; $g++)
		{
			$newpron = $newpron."-".$newpron1[$g];
		}
		$lexicon[$i] = $lexicon[$i]."/".$newpron;
		$where[$i]= $where[$i]."/".$newpron.$countwhichrule;
	}
}
#____________________________________________________________________________________________________
sub shortvowels
{
	@newpron1 = (); 
	$newpron = "";
	@syllables = split (/-/, $pronvar);
	$newpron1count = 0;
	for ($s= 0; $s <= $#syllables; $s++)
	{
		if ($syllables[$s] =~ /'/)			
		{
			$newpron1[$s] = $syllables[$s];
		}
		else
		{
			$newpron1[$s]= $syllables[$s];
			if($syllables[$s] !~ /[\+~:]/ && $syllables[$s] =~ /[ptkfsxh][AEOIY][hptkfsx]/)
			{	
				$newpron1[$s] =~ s/[AEOIY]//;
			}
			if ($newpron1[$s] ne $syllables[$s])
			{
				$newpron1count = 1;
			}		
		}
	}
	if ($newpron1count == 1)
	{
		$howoften1rule[$countwhichrule] = $howoften1rule[$countwhichrule] + 1;
		$newpron = $newpron1[0];
		for($g = 1; $g <=$#syllables; $g++)
		{
			$newpron = $newpron."-".$newpron1[$g];
		}
		$lexicon[$i] = $lexicon[$i]."/".$newpron;
		$where[$i]= $where[$i]."/".$newpron.$countwhichrule;
	}
}

sub shortvowels2
{
	@newpron1 = (); 
	$newpron = "";
	@syllables = split (/-/, $pronvar);
	$newpron1count = 0;
	for ($s= 0; $s <= $#syllables; $s++)
	{
		if ($syllables[$s] =~ /'/)			
		{
			$newpron1[$s] = $syllables[$s];
		}
		else
		{
			$newpron1[$s]= $syllables[$s];
			if($syllables[$s] !~ /[\+~:]/ && $syllables[$s] =~ /[AEOIY]/)
			{	
				$newpron1[$s] =~ s/[AEOIY]//;
			}
			if ($newpron1[$s] ne $syllables[$s])
			{
				$newpron1count = 1;
			}		
		}
	}
	if ($newpron1count == 1)
	{
		$howoften1rule[$countwhichrule] = $howoften1rule[$countwhichrule] + 1;
		$newpron = $newpron1[0];
		for($g = 1; $g <=$#syllables; $g++)
		{
			$newpron = $newpron."-".$newpron1[$g];
		}
		$lexicon[$i] = $lexicon[$i]."/".$newpron;
	}
}
#______________________________________________________________________________________
sub shortvowels_between_vn
{
	@newpron1 = (); 
	$newpron = "";
	@syllables = split (/-/, $pronvar);
	$newpron1count = 0;
	for ($s= 0; $s <= $#syllables; $s++)
	{
		if ($syllables[$s] =~ /'/)			
		{
			$newpron1[$s] = $syllables[$s];
		}
		else
		{
			$newpron1[$s]= $syllables[$s];
			if($newpron1[$s] =~ m/v[AEOIY]n/)
			{	
				$newpron1[$s] =~ s/[AEOIY]//g;
			}
			if($newpron1[$s] ne $syllables[$s])
			{
				$newpron1count = 1;
			}		
		}
	}
	if ($newpron1count == 1)
	{
		$howoften1rule[$countwhichrule] = $howoften1rule[$countwhichrule] + 1;
		$newpron = $newpron1[0];
		for($g = 1; $g <=$#syllables; $g++)
		{
			$newpron = $newpron."-".$newpron1[$g];
		}
		$lexicon[$i] = $lexicon[$i]."/".$newpron;
		$where[$i]= $where[$i]."/".$newpron.$countwhichrule;
	}
}
#________________________________________________________________________________________________________________
sub voweltoschwas
{
	@newpron2 = (); 
	$newpron = "";
	@syllables = split (/-/,$pronvar);
	$newpron1count = 0;
	for ($s= 0; $s <= $#syllables; $s++)
	{
		if ($syllables[$s] =~ /'/ || $syllables[$s] !~ /[\+~:]/)			
		{
			$newpron2[$s] = $syllables[$s];
		}
		else
		{
			$newpron2[$s]= $syllables[$s];	
			$newpron2[$s]=~ s/[ae2iIouy]/\@/;
			$newpron2[$s]=~ s/[AEOY]/\@/;
			if ($newpron2[$s]ne $syllables[$s])
			{
				$newpron1count = 1;
			}		
		}
	}
	if ($newpron1count == 1)
	{
		$howoften1rule[$countwhichrule] = $howoften1rule[$countwhichrule] + 1;
		$newpron = $newpron2[0];
		for($g = 1; $g <=$#syllables; $g++)
		{
			$newpron = $newpron."-".$newpron2[$g];
		}
		$lexicon[$i] = $lexicon[$i]."/".$newpron;
		$where[$i]= $where[$i]."/".$newpron.$countwhichrule;
	}
}
#________________________________________________________________________________________________________

sub voweltoschwas_limited
{
	$reference = 0;
	$newvariants = "";
	$head = "";
	$work= "";
	@tail = split (/-/,$pronvar);
	$reference = $#tail;

	#for: one reduced syllable per one stress
	&inspired_by_eric;
	
	#second reduced syllable if second stress
	if ($pronvar =~ /\S*'\S+'/)
	{
		@parts = split (/\//, $newvariants);
		for ($p=1; $p <= $#parts; $p++)
		{
			$reference = 0;
			$head = "";
			$work= "";
			@tail = split (/-/,$parts[$p]);
			$reference = $#tail;
			&inspired_by_eric;
		}
	}

	#and at the end we delete variants that occur twice
	@parts1 = ();
	@parts1 = split (/\//, $newvariants);
	for ($p=0; $p<= $#parts1; $p++)
	{
		$H_variants{$parts1[$p]}++;
	}
	@tobeaddtolexicon = keys(%H_variants);
	$letsjoineverythingtogether = join("/", @tobeaddtolexicon);
	$lexicon[$i] = $lexicon[$i]."/".$letsjoineverythingtogether;
	for ($p=0; $p<= $#parts1; $p++)
	{
		delete $H_variants{$parts1[$p]};
	}
}

sub inspired_by_eric
{

	$helpsme = $tail[0];
	$work = $tail[0];
	if ($work !~ /'/ && $work !~ /\@/ && $work !~ /[\+~:]/ )
	{
		$work=~ s/[ae2iIouy]/\@/;
		$work=~ s/[AEOY]/\@/;
	
		shift (@tail);
		$tail = join("-", @tail);
		$newvariants = $newvariants."/".$head."-".$work."-".$tail;
		@tail = (@tail, "");
		$newvariants =~ s/-\s*$//;
		$newvariants =~ s/^\///;
		$head = $head."-".$helpsme;
		@head = split (/-/, $head);
	}
	else
	{
		shift (@tail);
		@tail = (@tail, "");
		$head = $head."-".$helpsme;
		$head =~ s/-\s*$//;
		$head =~ s/^-//;
		@head = split (/-/, $head);
	}

	
	while ($tail[0] ne "")
	{
		&inspired_by_eric;
	}
}	
#__________________________________________________________________________________________________________________
sub igliding
{
	@newpron = (); 
	$newpron1 = "";
	@syllables = split (/-/,$pronvar);
	$newpron3count = 0;
	for ($s= 1; $s <= $#syllables; $s++)
	{
		if ($syllables[$s] =~ /'/)			
		{
			$newpron[$s] = $syllables[$s];
		}
		else
		{
			$newpron[$s]= $syllables[$s];	
			$newpron[$s]=~ s/i-([AEIOYaeiouy2])/j-$1/;
			$newpron[$s]=~ s/i-'([AEIOYaeiouy2])/j-'$1/;
			if ($newpron[$s] ne $syllables[$s])
			{
				$newpron3count = 1;
			}		
		}
	}
	if ($newpron3count == 1)
	{
		$howoften1rule[$countwhichrule] = $howoften1rule[$countwhichrule] + 1;
		$newpron1 = $newpron[0];
		for($g = 1; $g <=$#syllables; $g++)
		{
			$newpron1 = $newpron1."-".$newpron[$g];
		}
		$lexicon[$i] = $lexicon[$i]."/".$newpron1;
		$where[$i]= $where[$i]."/".$newpron1.$countwhichrule;
	}
}
#_____________________________________________________________________________________________________________
sub schwadelition_limited
{
	$reference = 0;
	$newvariants = "";
	$head = "";
	$work= "";
	@tail = split (/-/,$pronvar);
	$reference = $#tail;

	#for: one reduced syllable per one stress
	&inspired_by_eric2;
	
	#second reduced syllable if second stress

	@parts = split (/\//, $newvariants);
	for ($p=0; $p <= $#parts; $p++)
	{
		$reference = 0;
		$head = "";
		$work= "";
		@tail = split (/-/,$parts[$p]);
		$reference = $#tail;
		&inspired_by_eric2;
	}

	@parts1 = ();
	@parts1 = split (/\//, $newvariants);
	for ($p=0; $p<= $#parts1; $p++)
	{
		$H_variants{$parts1[$p]}++;
	}
	@tobeaddtolexicon = keys(%H_variants);
	$letsjoineverythingtogether = join("/", @tobeaddtolexicon);
	$lexicon[$i] = $lexicon[$i]."/".$letsjoineverythingtogether;
	for ($p=0; $p<= $#parts1; $p++)
	{
		delete $H_variants{$parts1[$p]};
	}
}

sub inspired_by_eric2
{

	$helpsme = $tail[0];
	$work = $tail[0];
	if ($work !~ /'/ && $work !~ /[AEIOYaeiouy2]/)
	{
		$work =~ s/\@//;
		shift (@tail);
		$tail = join("-", @tail);
		$newvariants = $newvariants."/".$head."-".$work."-".$tail;
		@tail = (@tail, "");
		$newvariants =~ s/-+\s*$//g;
		$newvariants =~ s/^\///g;
		$newvariants=~ s/^-+//g;
		$head = $head."-".$helpsme;
		@head = split (/-/, $head);
	}
	else
	{
		shift (@tail);
		@tail = (@tail, "");
		$head = $head."-".$helpsme;
		$head =~ s/-+\s*$//g;
		$head =~ s/^-+//g;
		@head = split (/-/, $head);
	}
	while ($tail[0] ne "")
	{
		&inspired_by_eric2;
	}
}
#__________________________________________________________________________________________________________________	
sub schwadelition
{
	@newpron2 = (); 
	$newpron = "";
	@syllables = split (/-/,$pronvar);
	$newpron1count = 0;
	for ($s= 0; $s <= $#syllables; $s++)
	{
		if ($syllables[$s] =~ /'/)			
		{
			$newpron2[$s] = $syllables[$s];
		}
		else
		{
			$newpron2[$s]= $syllables[$s];	
			$newpron2[$s]=~ s/\@//;
			if ($newpron2[$s]ne $syllables[$s])
			{
				$newpron1count = 1;
			}		
		}
	}
	if ($newpron1count == 1)
	{
		$howoften1rule[$countwhichrule] = $howoften1rule[$countwhichrule] + 1;
		$newpron = $newpron2[0];
		for($g = 1; $g <=$#syllables; $g++)
		{
			$newpron = $newpron."-".$newpron2[$g];
		}
		$lexicon[$i] = $lexicon[$i]."/".$newpron;
		$where[$i]= $where[$i]."/".$newpron.$countwhichrule;
	}
}
#_________________________________________________________________________________________________________________________
sub schwadelition1	#every schwa in an unstressed syllable can be deleted; but only one schwa per word; only for words with max 3 @as
{
	@newpron2 = (); 
	$newpron = "";
	$pronvar = $_[0];
	@syllables = split (/-/,$pronvar);
	$newpron1count = 0;
	for ($s= 0; $s <= $#syllables; $s++)
	{
		if ($syllables[$s] =~ /'/ || $newpron1count==1)			
		{
			$newpron2[$s] = $syllables[$s];
		}
		else
		{
			$newpron2[$s]= $syllables[$s];	
			$newpron2[$s]=~ s/\@//;
			if ($newpron2[$s]ne $syllables[$s])
			{
				$newpron1count = 1;
			}		
		}
	}
	if ($newpron1count == 1)
	{
		$howoften1rule[$countwhichrule] = $howoften1rule[$countwhichrule] + 1;
		$newpron = $newpron2[0];
		for($g = 1; $g <=$#syllables; $g++)
		{
			$newpron = $newpron."-".$newpron2[$g];
		}
		$lexicon[$i] = $lexicon[$i]."/".$newpron;
		$howoftenschwa1++;
	}
}
#_______________________________________________________________________________________________________________________________________________
sub schwadelition2	#every schwa in an unstressed syllable can be deleted; but only one schwa per word; only for words with max 3 @as
{
	@newpron2 = (); 
	$newpron = "";
	$pronvar = $_[0];
	@syllables = split (/-/,$pronvar);
	$newpron1count = 0;
	for ($s= 0; $s <= $#syllables; $s++)
	{
		if ($syllables[$s] =~ /'/||$newpron1count==2)			
		{
			$newpron2[$s] = $syllables[$s];
		}
		else
		{
			$newpron2[$s]= $syllables[$s];	
			$newpron2[$s]=~ s/\@//;
			if ($newpron2[$s]ne $syllables[$s])
			{
				$newpron1count = $newpron1count+1;
			}		
		}
	}
	if ($newpron1count == 2)
	{
		$howoften1rule[$countwhichrule] = $howoften1rule[$countwhichrule] + 1;
		$newpron = $newpron2[0];
		for($g = 1; $g <=$#syllables; $g++)
		{
			$newpron = $newpron."-".$newpron2[$g];
		}
		$lexicon[$i] = $lexicon[$i]."/".$newpron;
		$howoftenschwa2++;
	}
}
#________________________________________________________________________________________________________________________________________________________
sub lijkreduction
{
	@newpron= (); 
	$newpron1 = "";
	@syllables = split (/-/,$pronvar);
	$newpron1count = 0;
	for ($s= 0; $s <= $#syllables; $s++)
	{
		$newpron[$s]= $syllables[$s];
		if($syllables[$#syllables]=~ /l\@k$/)		
		{		
			$newpron[$#syllables]= "k";
			$newpron4="\@k";
		}
		if ($newpron[$s] ne $syllables[$s])
		{
			$newpron1count = 1;
		}	
	}					
	if ($newpron1count == 1)
	{
		$howoften1rule[$countwhichrule] = $howoften1rule[$countwhichrule] + 1;
		$newpron1 = $newpron[0];
		$newpron2 = $newpron[0];
		for($g = 1; $g <=$#syllables; $g++)
		{
			$newpron1 = $newpron1."-".$newpron[$g];
		}


		for($g = 1; $g <$#syllables; $g++)
		{
			$newpron2 = $newpron2."-".$newpron[$g];
		}
		$newpron2 = $newpron2."-".$newpron4;

		$lexicon[$i] = $lexicon[$i]."/".$newpron1."/".$newpron2;

		$where[$i]= $where[$i]."/".$newpron1.$countwhichrule;
		$where[$i]= $where[$i]."/".$newpron2.$countwhichrule;
	}
}
#_______________________________________________________________________________________________________
sub degemination
{
	$newpron = $_[0];

	$newpron =~ s/([pbtdkgfvszZxGhNmnJlrwj])-+\1/-$1/g;			#maximum onset principle
	$newpron =~ s/([pbtdkgfvszZxGhNmnJlrwj])-+'+\1/-'$1/g;
	$newpron =~ s/([pbtdkgfvszZxGhNmnJlrwj])\1/$1/g;

	$newpron =~ s/s-+z/-s/g;
	$newpron =~ s/s-+'+z/-'s/g;
	$newpron =~ s/z-+s/-s/g;
	$newpron =~ s/z-+'+s/-'s/g;
	$newpron =~ s/sz/s/g;
	$newpron =~ s/zs/s/g;

	$newpron =~ s/t-+d/-t/g;
	$newpron =~ s/t-+'+d/-'t/g;
	$newpron =~ s/d-+t/-t/g;
	$newpron =~ s/d-+'+t/-'t/g;
	$newpron =~ s/td/t/g;
	$newpron =~ s/dt/t/g;

	$newpron =~ s/p-+b/-p/g;
	$newpron =~ s/p-+'+b/-'p/g;
	$newpron =~ s/b-+p/-p/g;
	$newpron =~ s/b-+'+p/-'p/g;
	$newpron =~ s/pb/p/g;
	$newpron =~ s/bp/p/g;	
	$_[0] = $newpron;	
}
#_______________________________________________________________________________________________________________
sub fabsence_inpfl
{
	$newpron= $pronvar;
	$newpron=~ s/pfl/pl/g;				
	$newpron=~ s/pf-l/p-l/g;
	$newpron=~ s/p-'fl/p-'l/g;
	$newpron=~ s/p-fl/p-l/g;				
	$newpron=~ s/pf-'l/p-'l/g;
	if ($newpron ne $pronvar)
	{
		$lexicon[$i] = $lexicon[$i]."/".$newpron;
		$where[$i]= $where[$i]."/".$newpron.$countwhichrule;	
		$howoften1rule[$countwhichrule] = $howoften1rule[$countwhichrule] + 1;
	}	
}
#________________________________________________________________________________________________________________
sub tdelition_in_sclusters
{
	$newpron= $pronvar;
	$newpron=~ s/st-([pbkgfvszSZxGhNmnJlrwj])/s-$1/g;
	$newpron=~ s/st-'([pbkgfvszSZxGhNmnJlrwj])/s-'$1/g;
	$newpron=~ s/([pbkgfvszSZxGhNmnJlrwj])t-s/$1-s/g;
	$newpron=~ s/([pbkgfvszSZxGhNmnJlrwj])t-'s/$1-'s/g;
	$newpron=~ s/([pbkgfvszSZxGhNmnJlrwj])ts/$1s/g;
	
	if ($newpron ne $pronvar)
	{
		$lexicon[$i] = $lexicon[$i]."/".$newpron;
		$where[$i]= $where[$i]."/".$newpron.$countwhichrule;	
		$howoften1rule[$countwhichrule] = $howoften1rule[$countwhichrule] + 1;
	}
}
#_________________________________________________________________________________________________________________
sub tdeletion_before_plosives
{
	$newpron= $pronvar;
	$newpron=~ s/([AEIOYaeiouy2\@])t-([bpkg])/$1-$2/g;
	$newpron=~ s/([AEIOYaeiouy2\@])t-'([bpkg])/$1-'$2/g;	
	if ($newpron ne $pronvar)
	{
		$lexicon[$i] = $lexicon[$i]."/".$newpron;
		$where[$i]= $where[$i]."/".$newpron.$countwhichrule;	
		$howoften1rule[$countwhichrule] = $howoften1rule[$countwhichrule] + 1;
	}
}
#________________________________________________________________________________________________________________
sub tdelition_in_consonantclusters
{
	$newpron= $pronvar;
	$newpron =~ s/([pbkgfvzSZxGhNmnJlrwj])t-'b/$1-'b/g;
	$newpron =~ s/([pbkgfvzSZxGhNmnJlrwj])t-b/$1-b/g;
	$newpron =~ s/([pbkgfvzSZxGhNmnJlrwj])t-'p/$1-'p/g;
	$newpron =~ s/([pbkgfvzSZxGhNmnJlrwj])t-p/$1-p/g;
	$newpron =~ s/([pbkgfvzSZxGhNmnJlrwj])t-m/$1-m/g;
	$newpron =~ s/([pbkgfvzSZxGhNmnJlrwj])t-'m/$1-'m/g;
	if ($newpron ne $pronvar)
	{
		$lexicon[$i] = $lexicon[$i]."/".$newpron;
		$where[$i]= $where[$i]."/".$newpron.$countwhichrule;	
		$howoften1rule[$countwhichrule] = $howoften1rule[$countwhichrule] + 1;
	}
}
#_________________________________________________________________________________________________________________
sub tdeletion_in_finalposition				#final t deletion in coda position
{
	$newpron= $pronvar;
	$newpron=~ s/([pbkgfvzSZxGhNmnJlrwjs])t$/$1/;
	#$newpron=~ s/xt-/x-/g;
	if ($newpron ne $pronvar)
	{
		$lexicon[$i] = $lexicon[$i]."/".$newpron;
		$where[$i]= $where[$i]."/".$newpron.$countwhichrule;	
		$howoften1rule[$countwhichrule] = $howoften1rule[$countwhichrule] + 1;
	}	
}
#_________________________________________________________________________________________________________________________

sub voicing_finalobstruents	#its actually a crossover rule: when next word is starting with a voiced plosive the preceding obstruent can be voiced. changed to word level rule
{
	$newpron= $pronvar;
	$newpron=~ s/p$/b/;
	$newpron=~ s/t$/d/;
	$newpron=~ s/k$/g/;
	$newpron=~ s/f$/v/;
	$newpron=~ s/x$/G/;
	$newpron=~ s/S$/Z/;
	$newpron=~ s/s$/z/;
	if ($newpron ne $pronvar)
	{
		$lexicon[$i] = $lexicon[$i]."/".$newpron;
		$where[$i]= $where[$i]."/".$newpron.$countwhichrule;	
		$howoften1rule[$countwhichrule] = $howoften1rule[$countwhichrule] + 1;
	}	
}
#_________________________________________________________________________________________________________________________
sub habsence_hebben
{
	$newpron1 = $pronvar;	
	$newpron1=~ s/^'hEp/'Ep/g;				
	$newpron1=~ s/^'hE-b\@n/'E-b\@n/g;
	$newpron1=~ s/^'hE-b\@n/'E-b\@/g;
	$newpron1=~ s/^'hEpt/'Ept/g;
	$newpron1=~ s/^'heft/'eft/g;
	$newpron1=~ s/^'hAt/'At/g;
	$newpron1=~ s/^'hA-d\@n/'A-d\@n/g;
	$newpron1=~ s/^'hA-d\@n/'A-d\@/g;
	$newpron1=~ s/^hEt/Et/g;
	if ($newpron1 ne $pronvar)
	{
		$lexicon[$i] = $lexicon[$i]."/".$newpron1;
		$where[$i]= $where[$i]."/".$newpron1.$countwhichrule;	
		$howoften1rule[$countwhichrule] = $howoften1rule[$countwhichrule] + 1;
	}
}
#___________________________________________________________________
sub voiced_to_unvoiced_consonants
{
	$newpron1 = $pronvar;
	$newpron1=~ s/b([tdkgfvszSZxGh])/p$1/g;		#in obstruentcluster at the end or beginning of the syllable
	$newpron1=~ s/d([pbkgfvszSZxGh])/t$1/g;
	$newpron1=~ s/G([pbtdkgfvszSZh])/x$1/g;
	$newpron1=~ s/z([pbtdkgfvSZxGh])/s$1/g;
	$newpron1=~ s/v([pbtdkgszSZxGh])/f$1/g;

	$newpron1=~ s/b$/p/g;				#at the end of the word
	$newpron1=~ s/d$/t/g;
	$newpron1=~ s/G$/x/g;
	$newpron1=~ s/z$/s/g;
	$newpron1=~ s/v$/f/g;

	$newpron1=~ s/b-([tdkgfvszSZxGh])/p-$1/g;	#in between syllables		
	$newpron1=~ s/d-([pbkgfvszSZxGh])/t-$1/g;
	$newpron1=~ s/G-([pbtdkgfvszSZh])/x-$1/g;
	$newpron1=~ s/z-([pbtdkgfvSZxGh])/s-$1/g;
	$newpron1=~ s/v-([pbtdkgszSZxGh])/f-$1/g;

	$newpron1=~ s/b-'([tdkgfvszSZxGh])/p-'$1/g;	#in between syllables; following stressed			
	$newpron1=~ s/d-'([pbkgfvszSZxGh])/t-'$1/g;
	$newpron1=~ s/G-'([pbtdkgfvszSZh])/x-'$1/g;
	$newpron1=~ s/z-'([pbtdkgfvSZxGh])/s-'$1/g;
	$newpron1=~ s/v-'([pbtdkgszSZxGh])/f-'$1/g;
	if ($newpron1 ne $pronvar)
	{
		$lexicon[$i] = $lexicon[$i]."/".$newpron1;
		$where[$i]= $where[$i]."/".$newpron1.$countwhichrule;	
		$howoften1rule[$countwhichrule] = $howoften1rule[$countwhichrule] + 1;
	}
}
#_______________________________________________________________________________
sub delof_bilabialplosives_afterm
{
	$newpron1= $pronvar;	
	$newpron1=~ s/m[bp]/m/g;
	$newpron1=~ s/m-[bp]/m-/g;
	$newpron1=~ s/m-'[bp]/m-'/g;
	if ($newpron1 ne $pronvar)
	{
		$lexicon[$i] = $lexicon[$i]."/".$newpron1;
		$where[$i]= $where[$i]."/".$newpron1.$countwhichrule;	
		$howoften1rule[$countwhichrule] = $howoften1rule[$countwhichrule] + 1;
	}
}
#_________________________________________________________________________________________________________
sub consonant_in_ncluster
{
	$newpron1= $pronvar;	
	$newpron1=~ s/N([pbkgfvszSZxGhmJlrwj])/N/g; 
	$newpron1=~ s/n([pbkgfvszSZxGhmJlrwj])/n/g;
	if ($newpron1 ne $pronvar)
	{
		$lexicon[$i] = $lexicon[$i]."/".$newpron1;
		$where[$i]= $where[$i]."/".$newpron1.$countwhichrule;	
		$howoften1rule[$countwhichrule] = $howoften1rule[$countwhichrule] + 1;
	}
}
#______________________________________________________________________________________________________________________
sub ndelition_betweenvowel_ands
{
	$newpron1= $pronvar;	
	$newpron1=~ s/([AEIOYaeiouy2])n-s/$1-s/g;
	$newpron1=~ s/([AEIOYaeiouy2])n-'s/$1-'s/g;
	$newpron1=~ s/([AEIOYaeiouy2])ns/$1s/g;

	if ($newpron1 ne $pronvar)
	{
		$lexicon[$i] = $lexicon[$i]."/".$newpron1;
		$where[$i]= $where[$i]."/".$newpron1.$countwhichrule;	
		$howoften1rule[$countwhichrule] = $howoften1rule[$countwhichrule] + 1;
	}
}
#______________________________________________________________________________________________________________________
sub rdeletion_after_lowvowels
{
	$newpron1= $pronvar;	
	$newpron1=~ s/([AaoOy])r-/$1-/g;			        #coda of a syllable
	$newpron1=~ s/([AaoOy])r([pbtdkgfvszSZxGhNmnJlwj])-/$1$2-/g;		#coda of a syllable with two konsonants
	$newpron1=~ s/([AaoOy])r$/$1/g;			        	#end of word		
		
		
	if ($newpron1 ne $pronvar)
	{
		$lexicon[$i] = $lexicon[$i]."/".$newpron1;
		$where[$i]= $where[$i]."/".$newpron1.$countwhichrule;	
		$howoften1rule[$countwhichrule] = $howoften1rule[$countwhichrule] + 1;
	}
}
#______________________________________________________________________________________________________________________
sub rdeletion_after_schwa
{
	$newpron= $pronvar;	
	$newpron=~ s/\@r-/\@-/g;		#coda of syllable
	$newpron=~ s/\@r([pbtdkgfvszSZxGhNmnJlwj])-/\@$1-/g;
	$newpron=~ s/\@r([pbtdkgfvszSZxGhNmnJlwj])$/\@$1/g;
	$newpron=~ s/\@r$/\@/g;		#end of word
	if ($newpron ne $pronvar)
	{
		$lexicon[$i] = $lexicon[$i]."/".$newpron;
		$where[$i]= $where[$i]."/".$newpron.$countwhichrule;	
		$howoften1rule[$countwhichrule] = $howoften1rule[$countwhichrule] + 1;
	}
}
#______________________________________________________________________________________________________________________
sub extreme_reduced_words
{
	$orthography = $_[0];
	$newpron1= "";
	if ($orthography eq "niet")
	{
		$newpron1= "'ni";
		$lexicon[$i] = $lexicon[$i]."/".$newpron1;
		$where[$i]= $where[$i]."/".$newpron1."1000";#rule nr 1000 means extreme reduction, extralist		
		$howoftenextreme++;
	}
	if ($orthography eq "zelfde")
	{
		$newpron1= "'zEl-d\@";
		$lexicon[$i] = $lexicon[$i]."/".$newpron1;
		$where[$i]= $where[$i]."/".$newpron1."1000";		
		$howoftenextreme++;
	}
	if ($orthography eq "zelfs")
	{
		$newpron1= "'zEls";
		$lexicon[$i] = $lexicon[$i]."/".$newpron1;
		$where[$i]= $where[$i]."/".$newpron1."1000";		
		$howoftenextreme++;
	}
	if ($orthography eq "zelfs")
	{
		$newpron1= "'zEfs";
		$lexicon[$i] = $lexicon[$i]."/".$newpron1;
		$where[$i]= $where[$i]."/".$newpron1."1000";		
		$howoftenextreme++;
	}
	if ($orthography eq "als")
	{
		$newpron1= "'As";
		$lexicon[$i] = $lexicon[$i]."/".$newpron1;
		$where[$i]= $where[$i]."/".$newpron1."1000";		
		$howoftenextreme++;
	}	
	if ($orthography eq "eigenlijk")
	{
		$newpron1= "'E+k";
		$lexicon[$i] = $lexicon[$i]."/".$newpron1;
		$where[$i]= $where[$i]."/".$newpron1."1000";		
		$howoftenextreme++;
	}
	if ($orthography eq "natuurlijk")
	{
		$newpron1= "'tyk";
		$lexicon[$i] = $lexicon[$i]."/".$newpron1;
		$where[$i]= $where[$i]."/".$newpron1."1000";		
		$howoftenextreme++;
	}	
	if ($orthography eq "waarschijnlijk")
	{
		$newpron1= "w\@-'sxE+nk";
		$lexicon[$i] = $lexicon[$i]."/".$newpron1;
		$where[$i]= $where[$i]."/".$newpron1."1000";		
		$howoftenextreme++;
	}	
	if ($orthography eq  "dadelijk")
	{
		$newpron1= "'dak";
		$lexicon[$i] = $lexicon[$i]."/".$newpron1;
		$where[$i]= $where[$i]."/".$newpron1."1000";		
		$howoftenextreme++;
	}
	if ($orthography eq "koninklijk")
	{
		$newpron1= "'konk";
		$lexicon[$i] = $lexicon[$i]."/".$newpron1;
		$where[$i]= $where[$i]."/".$newpron1."1000";		
		$howoftenextreme++;
	}
	if ($orthography eq "namelijk")
	{
		$newpron1= "'namk";
		$lexicon[$i] = $lexicon[$i]."/".$newpron1;
		$where[$i]= $where[$i]."/".$newpron1."1000";		
		$howoftenextreme++;
	}
	if ($orthography eq "volgend")
	{
		$newpron1= "'folnt";
		$lexicon[$i] = $lexicon[$i]."/".$newpron1;
		$where[$i]= $where[$i]."/".$newpron1."1000";		
		$howoftenextreme++;
	}
	if ($orthography eq "allemaal")
	{
		$newpron1= "A-'m\@l";
		$lexicon[$i] = $lexicon[$i]."/".$newpron1;
		$where[$i]= $where[$i]."/".$newpron1."1000";		
		$howoftenextreme++;
	}
	if ($orthography eq "helemaal")
	{
		$newpron1= "'hem-\@l";
		$lexicon[$i] = $lexicon[$i]."/".$newpron1;
		$where[$i]= $where[$i]."/".$newpron1."1000";		
		$howoftenextreme++;
	}
	if ($orthography eq "daarom")
	{
		$newpron1= "'dam";
		$lexicon[$i] = $lexicon[$i]."/".$newpron1;
		$where[$i]= $where[$i]."/".$newpron1."1000";		
		$howoftenextreme++;
	}
	if ($orthography eq "mogelijk")
	{
		$newpron1= "'mok";
		$lexicon[$i] = $lexicon[$i]."/".$newpron1;
		$where[$i]= $where[$i]."/".$newpron1."1000";		
		$howoftenextreme++;
	}
	if ($orthography eq "ongeveer")
	{
		$newpron1= "'O~-fer";
		$lexicon[$i] = $lexicon[$i]."/".$newpron1;
		$where[$i]= $where[$i]."/".$newpron1."1000";		
		$howoftenextreme++;
	}
	if ($orthography eq "wedstrijd")
	{
		$newpron1= "'wEs";
		$lexicon[$i] = $lexicon[$i]."/".$newpron1;
		$where[$i]= $where[$i]."/".$newpron1."1000";		
		$howoftenextreme++;
	}
	if ($orthography eq "tandarts")
	{
		$newpron1= "'tAs";
		$lexicon[$i] = $lexicon[$i]."/".$newpron1;
		$where[$i]= $where[$i]."/".$newpron1."1000";		
		$howoftenextreme++;
	}
	if ($orthography eq "bijvoorbeeld")
	{
		$newpron1= "'vOlt";
		$lexicon[$i] = $lexicon[$i]."/".$newpron1;
		$where[$i]= $where[$i]."/".$newpron1."1000";		
		$howoftenextreme++;
	}
	if ($orthography eq "computer")
	{
		$newpron1= "'pu-t\@r";
		$lexicon[$i] = $lexicon[$i]."/".$newpron1;
		$where[$i]= $where[$i]."/".$newpron1."1000";		
		$howoftenextreme++;
	}
	if ($orthography eq "constant")
	{
		$newpron1= "'kOn-s\@n";
		$lexicon[$i] = $lexicon[$i]."/".$newpron1;
		$where[$i]= $where[$i]."/".$newpron1."1000";		
		$howoftenextreme++;
	}
	if ($orthography eq "dinsdag")
	{
		$newpron1= "'dI-za";
		$lexicon[$i] = $lexicon[$i]."/".$newpron1;
		$where[$i]= $where[$i]."/".$newpron1."1000";		
		$howoftenextreme++;
	}
	if ($orthography eq "maandag")
	{
		$newpron1= "'manz";
		$lexicon[$i] = $lexicon[$i]."/".$newpron1;
		$where[$i]= $where[$i]."/".$newpron1."1000";		
		$howoftenextreme++;
	}
	if ($orthography eq "precies")
	{
		$newpron1= "'psis";
		$lexicon[$i] = $lexicon[$i]."/".$newpron1;
		$where[$i]= $where[$i]."/".$newpron1."1000";		
		$howoftenextreme++;
	}
	if ($orthography eq "precies")
	{
		$newpron1= "'p\@-sis";
		$lexicon[$i] = $lexicon[$i]."/".$newpron1;
		$where[$i]= $where[$i]."/".$newpron1."1000";		
		$howoftenextreme++;
	}
	if ($orthography eq "publiek")
	{
		$newpron1= "'wlik";
		$lexicon[$i] = $lexicon[$i]."/".$newpron1;
		$where[$i]= $where[$i]."/".$newpron1."1000";		
		$howoftenextreme++;
	}
	if ($orthography eq "oktober")
	{
		$newpron1= "'to-w\@r";
		$lexicon[$i] = $lexicon[$i]."/".$newpron1;
		$where[$i]= $where[$i]."/".$newpron1."1000";		
		$howoftenextreme++;
	}
	if ($orthography eq "gewoon")
	{
		$newpron1= "'xon";
		$lexicon[$i] = $lexicon[$i]."/".$newpron1;
		$where[$i]= $where[$i]."/".$newpron1."1000";		
		$howoftenextreme++;
	}
	if ($orthography eq "gaan")
	{
		$newpron1= "'x\@";
		$lexicon[$i] = $lexicon[$i]."/".$newpron1;
		$where[$i]= $where[$i]."/".$newpron1."1000";		
		$howoftenextreme++;
	}
	if ($orthography eq "bepaalde")
	{
		$newpron1= "'pa-l\@";
		$lexicon[$i] = $lexicon[$i]."/".$newpron1;
		$where[$i]= $where[$i]."/".$newpron1."1000";		
		$howoftenextreme++;
	}
	if ($orthography eq "anders")
	{
		$newpron1= "'As";
		$lexicon[$i] = $lexicon[$i]."/".$newpron1;
		$where[$i]= $where[$i]."/".$newpron1."1000";		
		$howoftenextreme++;
	}
}

#_____________________________________________________________________________________________
sub function_words
{
	$orthography = $_[0];
	$pronunciation = $_[1];
	$newpron1= "";
	if ($orthography eq "aan" ||$orthography eq "aangezien" ||$orthography eq "aar" ||$orthography eq "achter" ||$orthography eq "af" ||$orthography eq "afgezien" ||$orthography eq "afijn" ||$orthography eq "al" ||$orthography eq "alle" || $orthography eq "allebei" ||$orthography eq "alleen" ||$orthography eq "allen" ||$orthography eq "aller" ||$orthography eq "alles" ||$orthography eq "als" ||$orthography eq "alsjeblieft" ||$orthography eq "alsof" ||$orthography eq "an"|| $orthography eq "een" ||$orthography eq "eer" ||$orthography eq "ei" ||$orthography eq "eigen" ||$orthography eq "elk" ||$orthography eq "elkaar" ||$orthography eq "elke" ||$orthography eq "en" ||$orthography eq "ene" ||$orthography eq "enige/" ||$orthography eq "enigen" ||$orthography eq "enigste" ||$orthography eq "enkel" ||$orthography eq "enkele" ||$orthography eq "er" ||$orthography eq "ergens" ||$orthography eq "ervoor" ||$orthography eq "even" ||$orthography eq "evenveel" ||$orthography eq "extra" ||$orthography eq "ieder" ||$orthography eq "iedere" ||$orthography eq "iedereen" ||$orthography eq "iemand" ||$orthography eq "iet" ||$orthography eq "iets" ||$orthography eq "ik" ||$orthography eq "ikke" ||$orthography eq "ikzelf"||$orthography eq  "in" ||$orthography eq "ergens" ||$orthography eq "of" ||$orthography eq "ofwel" ||$orthography eq "ola" ||$orthography eq "om" ||$orthography eq "omdat" ||$orthography eq "omheen" ||$orthography eq "on" ||$orthography eq "ondanks" ||$orthography eq "onder" ||$orthography eq "ons" ||$orthography eq "onszelf" ||$orthography eq "onze" ||$orthography eq "ook"||$orthography eq "op" ||$orthography eq "open" ||$orthography eq "over" ||$orthography eq "overal" ||$orthography eq "uit")
	{
		$newpron1 = $pronunciation;
		$newpron1 =~ s/^[iye2aouIEAOY]//;
		$newpron1 =~ s/^'[iye2aouIEAOY]/'/;
		$newpron1 =~ s/^'[\+:~]/'/;		#these are still here if first vowel was a diphthong
		$newpron1 =~ s/^[\+:~]//;
		$lexicon[$i] = $lexicon[$i]."/".$newpron1;
		$where[$i]= $where[$i]."/".$newpron1."1001";#rule nr 1001 means function word, extralist		
		$howoftenfunctionword++;
	}
}
#___________________________________________________________________________________________________
