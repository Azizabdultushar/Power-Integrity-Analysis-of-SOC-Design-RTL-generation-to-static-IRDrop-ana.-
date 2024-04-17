#! /bin/bash

echo "new output"
echo "new output as file">output.txt


#this is huge comment
#Hi this is a comment

#if else condition
x=10
if [ $x -eq 5 ]
then
    echo "this is five"
else
    echo "this is wrong number"
fi


y=500

if [ $y -eq 200 ]
then
    echo "this is the real number $y"
elif [ $y -eq 300 ]
then
    echo " this is else if"
else
    echo " this is complete else"
fi



#while loop
