#!/bin/bash
### Exporting variables is a way to make a variable available to other processes or scripts that are run from the current shell. When you export a variable, it becomes part of the environment of the current shell and can be accessed by any child processes or scripts that are run from that shell. This is useful when you want to pass information between different scripts or processes.
### To export a variable, you can use the export command followed by the variable name. For 
## we want to make variable permanent sort of. 
SEASON="Summer"
export SEASON
## exported variables are available to all child processes and scripts that are run from the current shell.
## if we want everyone to be able to access the variable we can add it to the /etc/environment file.
## or every user has a .bashrc file in their home directory. we can add the export command to that file to make the variable available to all users.

## so in bashrc file we can add the following line to export the variable:
## export SEASON="Summer"
# source ~/.bashrc what this does is to reload the bashrc file so that the changes take effect immediately.

# now if you want it for every user you can edit /etc/profile file and add the export command to that file. this will make the variable available to all users on the system.
# if you want to make the variable available to all users and all processes on the system, you can add the export command to the /etc/environment file. this file is read by the system at boot time and is used to set environment variables for all users and processes on the system.
# hence in summary make variable avaalable to everyon edit /etc/profile, for user .bashrc, for all users and processes /etc/environment.