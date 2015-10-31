#!/usr/bin/perl
#Taylor Brockhoeft
#Unix Tools
#Friday, October 30th 2015

use strict;

my @wordlist = ();#Loads the dictionary of same length words

# READ AND HANDLE ARGS ==============================================================================
my $count = 0;
map { $count++ } @ARGV;

if ($count != 2){ #UNCOMMENT THIS LATER
	die "Must have a start and end word";
}

#If enough args, pass them into Argv
my $start = $ARGV[0];
my $end = $ARGV[1];

#If length is not equal, bail
if (length($start) != length($end)){
	die "Start and End word length are not equal, exiting program\n";
}
# END READ AND HANDLE ARGS ==========================================================================

#Temporary for while working
#my $ostart = "food";#Default start and end words
#my $oend  = "gold";


# LOAD THE DICTIONARY FILE  =========================================================================
my $filename = 'wordlist';
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



# TRY TO FIND PATH OF WORDS =========================================================================
#initilize array queues for words to process
#start = 0
#end = 1

#my @queue = ([$start],[$end]); #my @queue = ([[$word[0]], 'break'], [[$word[1]], 'break']);
my @queue = ([[$start]], [[$end]]);

#Create Two Word Candidates list so we can work back and forth between each side until we come to a solution
#This should make it faster
my @candidates = ({$start => []}, {$end => []});
#Swap between the start word and end word lists
my $switch = 0; 
#Contains (or not, I havent tests fake words) the path solution
my @path;
                        

while (1) { 

    my $w = shift @{$queue[$switch]};#grab first word on queue (start or end depending on switch)

    if ($w) {
	    my $x = $w->[-1];#since queue is array, derefference

	    my @similarwords = findsimilar($x); #Get list of one letter differences   

	    #print "$x\t@similarwords\n";         

	    my $word;
	    foreach $word (@similarwords) {
	        if ($candidates[$switch ^ 1]{$word}) { #If it's in the candidate list for the other word, then we've made a complete path
	            @path = (@$w, $word, reverse @{$candidates[$switch ^ 1]{$word}});
	            print "solution found @path\n";
	        }

            if ($candidates[$switch]{$word}){#If it's in the candidate list for itself, skip it, we dont need it
	        	#print "$word  already in\n";
                next;
            }

	        $candidates[$switch]{$word} = [@$w];  #updatecandidate words
	        
	        push @{$queue[$switch]}, [@$w, $word];  #push new word to queue

	    }
	                                        
    }
    else{
    	last; #DO A BARREL ROLL
    }

}


if (@path) {# found a path
	pop @path;#remove the last element because we alreay know what it is and will make print much easier
    #print "$start --> ";
    foreach my $thingamajigger (@path){
    	print "$thingamajigger --> "
    }
    print "$end\n";
}
else{
	print "no path found!\n";
}




exit 0; #done

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

