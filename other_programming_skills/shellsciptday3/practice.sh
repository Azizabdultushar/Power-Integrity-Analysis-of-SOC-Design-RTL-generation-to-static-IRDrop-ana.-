#! /bin/bash


#!/bin/bash

#################################
# normal arithmatic calculation #
#################################
echo 
echo "How many hours I am able to do work at Fraunhofer"
echo
work_hour=140
total_hours=$((140*8))
monthly_work_hour=$((total_hours/12))
echo "Monthly work hour:$monthly_work_hour"
echo

##############################
# if else condition          #
##############################

if [ $monthly_work_hour -eq 95 ]; then
    echo "you are not allow to work more"
else
    echo "your work load is absoutely okay enjoy "
fi

##############################
# if elseif else condition   #
##############################


if [ $monthly_work_hour -ge 45 ]; then

echo "your work hour is less or equal 45"

elif [ $monthly_work_hour -le 20 ]; then
echo "less then or equal 20"

else
echo "Bro you are completely poor"

fi

##############################
# if else conditional        #
##############################

dress="white"

if (($monthly_work_hour == 20 || $dress == "white")); then
echo "Work hour is 20 and white dress"

else
echo "bro you are so cool"

fi

##############################
# if else conditional        #
##############################

student_id=608801
degree="CMM"

if (($degree =="CMM" && student_id == 608801)); then
echo "the student is allowed to work as long as he wants"

elif (($degree =="CMM" || student_id == 608812)); then
echo "the student working is limited"

else
echo "the should go out"

fi

##############################
# For loop                   #
##############################



##############################
# while loop                 #
##############################










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
