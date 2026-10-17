#!/bin/bash
##System variables are built in variables that are available to all users and processes on the system. They are set by the system and can be used to access information about the system and the environment. Some common system variables include:
# $HOME: The home directory of the current user.
# $USER: The username of the current user.
# $SHELL: The shell being used by the current user.
# $PATH: The directories that the shell searches for executable files.
# $PWD: The current working directory.
# $UID: The user ID of the current user.    
# $HOSTNAME: The hostname of the system.
# $#: The number of arguments passed to the script.
# $@: All the arguments passed to the script.
# $$: The process ID of the current shell.
# $?: The exit status of the last command executed.
# $Line: The current line number in the script.
# $LINENO: The current line number in the script.
# $SECONDS: The number of seconds since the script started executing.
# $RANDOM: A random number between 0 and 32767.

### COmmand substitution is a feature of the shell that allows you to use the output of a command as an argument to another command. It is done by enclosing the command in backticks (`) or by using the $(command) syntax. For example, you can use command substitution to get the current date and time and use it as an argument to the echo command:
now=$(date)
echo "The current date and time is: $now"

## you can also use backticks to achieve the same result:
now=`whoami`
echo "The current user is: $now"

## You can use it to give varables values from the output of a command. For example, you can use command substitution to get the current working directory and save it to a variable: or long commands
FREE_SPACE=$(df -h / | awk 'NR==2 {print $4}')
echo "The free space on the root partition is: $FREE_SPACE"

##The sample script to welcome and user and get infor of the system
echo "Welcome, $USER! on $HOSTNAME"
echo "##################"

FREE_RAM=$(free -m | grep Mem | awk '{print $4}')
LOAD=$(uptime | awk -F'load average:' '{ print $2 }' | cut -d, -f1)
ROOTFREE=$(df -h / | awk 'NR==2 {print $4}')
echo "The free RAM on the system is: $FREE_RAM MB"
echo "The current load average on the system is: $LOAD"
echo "The free space on the root partition is: $ROOTFREE"