to check the shells list
$ cat /etc/shells

to check currect terminal session (bash/dash/cshell)
$ ps

to check all the item with list view
$ ls -al
$ ls -a

to make an empty file/shell file
$ touch bashworld.sh

to edit the file
$ emacs bashworld.sh

sample file of shell script

#! /bin/bash
echo "this is the first script of my bash learniing world"

to make the file executable after this command the color of the file will be changer
$ chmod +x ./bashworld.sh

to run the bash script
$ ./bashworld.sh

to take the output of the bash script into a separate file, add this
$ #! /bin/bash
$ echo "hello world" >bashoutput.txt

to see the output of bashoutput.txt
$ cat bashoutput.txt

