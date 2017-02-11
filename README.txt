There are 2 scripts in the solution.

See below for location and path info

[root@gpfs1 ~]# ls /gpfs/gpfsfpo/HW4/*.sh
/gpfs/gpfsfpo/HW4/download_goog_2gram_zips.sh  /gpfs/gpfsfpo/HW4/mumbler.sh


1. The download_goog_2gram_zips.sh is used for downloading the google ngram files and distributing them to the 3 nodes - gpfs1, gpfs2 and gpfs3. This has already been done and files are located at /root/tmp/bigramZips directory in each node.

2. The second is the mumbler script. The usage is as follows - 

Usage: mumbler start_word mumble_length

The script as coded run on the entire set of zip files. It takes about 30-40 mins for 1 pass through the set. It runs considerably faster for a smaller set of the files. I found that bash shell script ran the best for me than the python code. Python code involved significant amount of preprocessing - which itself took days to run. Further improvement in pass time can be accomplished by running the zgrep ssh command in parallel on the nodes. I did not have the time to attempt that. 

I did attempt setting up the locale to ASCII to speed up the grepping process. But this showed little improvement as I was using regex expression to locate the start_word at the begining of the bigram.

Here is the console output when the program runs

[root@gpfs1 HW4]# ./mumbler.sh financial 2
**********************
Pass - 1
Searching on GPFS1 - financial
Searching on GPFS2 - financial
Searching on GPFS3 - financial
File size - 371478
Next search term picked with probability - emancipation
**********************
Pass - 2
Searching on GPFS1 - emancipation
Searching on GPFS2 - emancipation
Searching on GPFS3 - emancipation
File size - 51790

