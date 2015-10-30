#!/usr/bin/perl
#Taylor Brockhoeft
#Unix Tools
#Thursday, October 22nd 2015

use strict;

my @wordlist = ();#Loads the dictionary of same length words

# READ AND HANDLE ARGS ==============================================================================
# my $count = 0;
# map { $count++ } @ARGV;

# if ($count != 2){ #UNCOMMENT THIS LATER
# 	die "Must have a start and end word";
# }

# #If enough args, pass them into Argv
# my ($start,$end) = $ARGV;

# #If length is not equal, bail
# if (length($start) != length($end)){
# 	die "Start and End word length are not equal, exiting program\n";
# }
# END READ AND HANDLE ARGS ==========================================================================

#Temporary for working
my $start = "food";#Default start and end words
my $end  = "gold";

# LOAD THE DICTIONARY FILE  =========================================================================
my $filename = 'smalllist';
open(my $fh,'<',$filename) or die "Failed to load '$filename'";

while ( my $row = <$fh> ) {
    chomp( $row );
    if (length $row == length $start){
    	push(@wordlist, $row);
    	#print "$row\n"
    }
}

close($fh);
# END LOAD DICTIONARY ===============================================================================


my $string = "foobar";
my @candidates;
my @levels;

my @returnfromfindsimilar = ();


my @candids = findsimilar($start);
print "STEP\t@candids\n";

sub findsimilar{
	#findsimilar compares a word to a list of words in wordlist, and returns ALL the one letter similar words. (for each char in the starting word)
	#Init params 
	my($word) = (@_);

	#Return Array of candid(ates)
	my @candid = ();

  		foreach my $query (@wordlist){ #For each word in the dictionary
				if (issimilar($word,$query)!=-1){
					#print $word;
					my ($word, $i) = issimilar($word,$query);	
					push(@candid,$word);
				}
				else{
					#print "NOT \t$query\n";
				}
  		}#first for loop
	

	#use hashmap to delete dupliacate elements
	my %unique = ();
	foreach my $item (@candid)
	{
	    $unique{$item} ++;
	}
	my @uniquecandid = keys %unique;

	foreach my $thing (@uniquecandid){
		#print "$thing\n";
	}

	return @uniquecandid;
}

sub issimilar{
	#Check for one letter difference between two words
	#returns the word and the index
	my($word,$other) = (@_);
	my @wordsplit = split("",$word);
	my @othersplit = split("",$other);
	my $index = 0;
	my $count = 0;

	#print "\n$word,$other\n";

	for (my $i=0; $i < length $word; $i++) {
   			if ($wordsplit[$i] ne $othersplit[$i]){
   				$count += 1;
   				$index = $i;
   			}
	}
	
	if ($count==1){#If only one difference, then 
		#print "return\t$other\t$index";
		return ($other,$index);
	}

	return -1;#Either more than one or no differences
}

