#!/bin/bash
myname="Manasseh"
myage="40"
now=$(date)

echo $myname # access vairable name
echo "Hello, my name is $myname"
echo "I'm $myage years old"

echo "The sytem time and date is: "
echo "$now"
files=$(ls) # you can save a vairable to an output of a command
echo "$files"
#./variables.sh
# variable referencing must be in double quotes
#varaibles arent persistent . they arent ssaved after a sesstion
#A sub shell e.g the ls task is done int back ground also $(pwd)
# variaves in all caps are mostly built in the underlying system