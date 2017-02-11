#!/bin/bash

<<'COMMENT'
Validation for mumbler command line input arguments.
COMMENT

if [ $# -eq 0 ]
  then
    echo "No arguments supplied"
    echo "Usage: mumbler start_word mumble_length"	
fi

re='^[0-9]+$'
if  [[ $1 =~ $re ]] ; then
    echo "error: Numeric value not allowed for start_word" >&2; exit 1
    echo "Usage: mumbler start_word mumble_length"	
fi

if ! [[ $2 =~ $re ]] ; then
    echo "error: Numeric value needed for mumble_length" >&2; exit 1
    echo "Usage: mumbler start_word mumble_length"	
fi

term=$1

<<'COMMENT'
Search for start_word in the all zip files on different nodes. The zgrep command searches for the start_word and selects all the bigrams starting with start_word.
The command simply retrieves all the occurance and stores them in a temporary "dummy" file. This is run for all the 3 nodes. The entries are not de-duped and sorted. 
The reason for that is that this gives a random distribution of the bigrams in the file. Hence when we select a line number at random from that file, the bigram at that line number is picked up in line with its weighted probability.
COMMENT

for i in $(seq 1 $2);
   do
	echo "**********************"
        echo "Pass - "$i;
	echo "Searching on GPFS1 - "$term;
	result1=`ssh -T gpfs1 << EOF
	LC_ALL=C zgrep -o -w "^$term [A-Za-z]\+" /root/tmp/bigramZips/google-2gram-*.zip
EOF`
        #echo "Result from GPFS1 - "$result1
	echo "$result1\n" >> dummy
	echo "Searching on GPFS2 - "$term;
	result2=`ssh -T gpfs2 << EOF
	LC_ALL=C zgrep -o -w "^$term [A-Za-z]\+" /root/tmp/bigramZips/google-2gram-*.zip
EOF`
        #echo "Result from GPFS2 - "$result2
	echo "$result2\n" >> dummy
	echo "Searching on GPFS3 - "$term;
	result3=`ssh -T gpfs3 << EOF
	LC_ALL=C zgrep -o -w "^$term [A-Za-z]\+" /root/tmp/bigramZips/google-2gram-*.zip
EOF`
        #echo "Result from GPFS3  - "$result3
	echo "$result3\n" >> dummy

	# Select a line with weighted probability from dummy
	#result=$(sort -rnk3 dummy) 
        size="$(wc -l <"dummy")"
        echo "File size - "$size
	rand_position=$(echo $(( $RANDOM % $size + 1)))
        #echo $rand_position
        result=$(sed "${rand_position}q;d" dummy)
        #echo $result
	term=$(echo $result | tr " " "\n" | tail -1)
	echo "Next search term picked with probability - "$term
	rm dummy
   done

