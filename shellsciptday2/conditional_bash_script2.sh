#! /bin/bash
#Author:ABdul Aziz
#Date: 16.04.2024


#Defining the variables
count=10

#In if condition there should be a space after and before parenthesis

if (( $count < 4 ))
then
    echo "this is right"
    
elif (( $count > 8 )) 
then
    echo "this condition is else if"
     
else
    echo "this is wrong"
fi



#not equal to
#  if [ $count -ne 10 ]
#greater than
#  if (( $count < 10 ))
#less than
#   if (( $count > 10))
