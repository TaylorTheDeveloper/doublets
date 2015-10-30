#!/usr/bin/perl
#Taylor Brockhoeft
#Unix Tools
#Thursday, October 22nd 2015

use strict;

my @wordlist = ();#Loads the dictionary of same length words

# READ AND HANDLE ARGS
my $count = 0;
map { $count++ } @ARGV;
print $count;

# if ($count != 2){ #UNCOMMENT THIS LATER
# 	die "Must have a start and end word";
# }

#If enough args, pass them into Argv
my ($start,$end) = $ARGV;

#If length is not equal, bail
if (length($start) != length($end)){
	die "Start and End word length are not equal, exiting program\n";
}
# END READ AND HANDLE ARGS

#Temporary for working
my $start = "chaos";#Default start and end words
my $end  = "order";

my $filename = 'smalllist';
open(my $fh,'<',$filename)
	or die "Failed to load '$filename'";

while ( my $row = <$fh> ) {
    chomp( $row );
    if (length $row == length $start){
    	push(@wordlist, $row);
    	#print "$row\n"
    }
}

my $string = "foobar";
my @candidates;
my @levels;

my @returnfromfindsimilar = ();


sub findsimilar{
	#findsimilar compares a word to a list of words, and returns ALL the one letter similar words. (for each char in the starting word)
	#Init params 
	my($word,@list) = (@_);

	#Return Array
	my @candid = ();

  		foreach my $query (@list){ #For each word in the dictionary
				if (issimilar($word,$query)!=-1){
					my ($word, $i) = issimilar($word,$query),"\n";	
					print $word;		
				}
				else{
					print "$query\n";
				}
  		}#first for loop
	

	#use hashmap to delete dupliacate elements
	my %unique = ();
	foreach my $item (@candid)
	{
	    $unique{$item} ++;
	}
	my @uniquecandid = keys %unique;

	return @uniquecandid;
}

sub issimilar{
	#Check for one letter difference between two words
	#returns the word and the index
	my($word,$other) = (@_);
	my $count = 0;
	my @wordsplit = split("",$word);
	my @othersplit = split("",$other);
	my $index = 0;

	#print "\n$word,$other\n";

	for (my $i=0; $i <= 9; $i++) {
   			if ($wordsplit[$i] eq $othersplit[$i]){
   				#print "$wordsplit[$i]\t$othersplit[$i]\n";
   			}
   			else{
   				$count += 1;
   				$index = $i;
   			}

	}
	
	if ($count==1){
		#print "return\t$other\t$index";
		return ($other,$index);
	}

	return -1;#Either more than one or no differences
}

findsimilar($start,@wordlist);
