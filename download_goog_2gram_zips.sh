#!/bin/bash

case "$1" in
        gpfs1)
            ssh gpfs1 << EOF
		mkdir -p /root/tmp/bigramZips
		for i in {0..33}
			do
			echo \$i
			wget -O /root/tmp/bigramZips/google-2gram-\$i.zip http://storage.googleapis.com/books/ngrams/books/googlebooks-eng-all-2gram-20090715-\$i.csv.zip
			done
EOF
            ;;
         
        gpfs2)
            ssh gpfs2 << EOF
		mkdir -p /root/tmp/bigramZips
            	for i in {34..66}
				do
				echo \$i
				wget -O /root/tmp/bigramZips/google-2gram-\$i.zip http://storage.googleapis.com/books/ngrams/books/googlebooks-eng-all-2gram-20090715-\$i.csv.zip
				done
EOF
            ;;
         
        gpfs3)
            ssh gpfs3 << EOF
		mkdir -p /root/tmp/bigramZips
            	for i in {67..99}
				do
				echo \$i
				wget -O /root/tmp/bigramZips/google-2gram-\$i.zip http://storage.googleapis.com/books/ngrams/books/googlebooks-eng-all-2gram-20090715-\$i.csv.zip
				done
EOF
            ;;
        *)
            echo $"Usage: $0 {gpfs1|gpfs2|gpfs3}"
            exit 1
 
esac

