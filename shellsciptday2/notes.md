
###########################################################################################
#! /bin/bash

count=10

if [ $count -eq 9 ] #In if condition there should be a space after and before parenthesis
then
    echo "this is right" 
else
    echo "this is wrong"
fi

###########################################################################################

#not equal to
if [ $count -ne 10 ]

#greater than
if (( $count << 10 ))

#less than
if (( $count >> 10))
	 