# Bash Scripting Complete Guide

> A comprehensive guide to Bash scripting for Linux, DevOps, Cloud Engineering, and Automation.

---

# Table of Contents

1. What is Bash?
2. Why Learn Bash?
3. Where Bash is Used
4. Bash vs Shell
5. Running Bash Scripts
6. Script Structure
7. Variables
8. Environment Variables
9. User Input
10. Comments
11. Output
12. Command Line Arguments
13. Exit Status
14. Operators
15. Conditional Statements
16. Loops
17. Functions
18. Arrays
19. String Manipulation
20. Arithmetic
21. File Operations
22. Directory Operations
23. Reading Files
24. Process Management
25. Pipes and Redirection
26. Command Substitution
27. Useful Linux Commands
28. Scheduling Scripts
29. Error Handling
30. Debugging
31. Best Practices
32. Security Best Practices
33. Real World Examples
34. Interview Questions
35. Common Mistakes
36. Cheat Sheet

---

# What is Bash?

**Bash (Bourne Again Shell)** is the default command-line interpreter for most Linux distributions.

It allows you to:

- Execute Linux commands
- Automate repetitive tasks
- Manage servers
- Deploy applications
- Process files
- Schedule jobs
- Create powerful automation scripts

Think of Bash as the programming language of Linux.

---

# Why Learn Bash?

Bash is heavily used in:

- DevOps
- Cloud Engineering
- System Administration
- Cybersecurity
- Backend Engineering
- Data Engineering
- CI/CD Pipelines
- Docker
- Kubernetes
- Terraform automation

Knowing Bash saves hours of manual work.

Example:

Instead of renaming 500 files manually...

```bash
for file in *.jpg
do
mv "$file" "image_$file"
done
```

Done in seconds.

---

# Bash vs Shell

Shell is a program that accepts commands.

Different shells exist:

- sh
- bash
- zsh
- fish
- ksh

Bash is simply one shell.

You can check yours:

```bash
echo $SHELL
```

Example output:

```
/bin/bash
```

---

# Running Bash Scripts

Create a file

```bash
nano hello.sh
```

Example

```bash
#!/bin/bash

echo "Hello World"
```

Give permission

```bash
chmod +x hello.sh
```

Run

```bash
./hello.sh
```

or

```bash
bash hello.sh
```

---

# The Shebang

The first line

```bash
#!/bin/bash
```

tells Linux which interpreter should execute the file.

Without it:

Linux doesn't know which shell to use.

---

# Comments

Single line

```bash
# This is a comment
```

Multi-line

```bash
: '

This is
a multiline
comment

'
```

---

# Variables

```bash
name="John"

echo $name
```

Output

```
John
```

Good practice

```bash
echo "$name"
```

Always quote variables.

---

# Variable Rules

Valid

```bash
age=20

student_name="David"

_course="Linux"
```

Invalid

```bash
2age=30

my name="John"

user-name="David"
```

---

# Read User Input

```bash
read name

echo "Hello $name"
```

Prompt user

```bash
read -p "Enter your name: " name
```

Password

```bash
read -sp "Password: " password
```

---

# Constants

```bash
readonly PI=3.14
```

or

```bash
declare -r PI=3.14
```

---

# Environment Variables

Display

```bash
echo $HOME

echo $USER

echo $PATH
```

Create

```bash
export APP_ENV=production
```

---

# Output

```bash
echo "Hello"

printf "Age: %d\n" 20
```

Difference

echo is simple.

printf offers formatting.

---

# Command Line Arguments

```bash
./script.sh John 25 Lagos
```

Inside script

```bash
echo $1
echo $2
echo $3
```

Output

```
John
25
Lagos
```

Useful variables

```
$0 → script name

$# → number of arguments

$@ → all arguments

$* → all arguments

$$ → process ID

$? → previous exit code
```

---

# Exit Status

Linux commands return

```
0 = Success

Anything else = Failure
```

Example

```bash
mkdir test

echo $?
```

---

# Arithmetic

```bash
x=5

y=3

echo $((x+y))
```

Operators

```
+

-

*

/

%

**

```

---

# Strings

Length

```bash
name="Manasseh"

echo ${#name}
```

Concatenate

```bash
first="John"

last="Doe"

echo "$first $last"
```

Substring

```bash
echo ${name:0:4}
```

Replace

```bash
echo ${name/John/Jane}
```

---

# Arrays

```bash
fruits=("Apple" "Orange" "Banana")
```

Print

```bash
echo ${fruits[0]}
```

All

```bash
echo ${fruits[@]}
```

Length

```bash
echo ${#fruits[@]}
```

---

# If Statement

```bash
if [ "$age" -ge 18 ]
then
echo "Adult"
fi
```

---

# if else

```bash
if [ "$age" -ge 18 ]
then
echo Adult
else
echo Child
fi
```

---

# Multiple Conditions

```bash
if [ "$age" -gt 18 ] && [ "$country" == "Nigeria" ]
then
echo "Allowed"
fi
```

---

# Case Statement

```bash
case $fruit in

apple)

echo Apple

;;

orange)

echo Orange

;;

*)

echo Unknown

;;

esac
```

Cleaner than many if statements.

---

# Loops

For loop

```bash
for i in {1..5}
do
echo $i
done
```

While loop

```bash
count=1

while [ $count -le 5 ]
do
echo $count
((count++))
done
```

Until

```bash
until [ $count -gt 5 ]
do
echo $count
((count++))
done
```

---

# Functions

```bash
greet(){

echo "Hello"

}

greet
```

Parameters

```bash
greet(){

echo "Hello $1"

}

greet John
```

Return

```bash
square(){

echo $(($1*$1))

}
```

---

# File Checks

Exists

```bash
[ -f file.txt ]
```

Directory

```bash
[ -d folder ]
```

Readable

```bash
[ -r file.txt ]
```

Writable

```bash
[ -w file.txt ]
```

Executable

```bash
[ -x file.sh ]
```

---

# Reading Files

Method 1

```bash
while read line
do
echo $line
done < users.txt
```

Method 2

```bash
cat users.txt
```

---

# File Operations

Copy

```bash
cp a.txt b.txt
```

Move

```bash
mv a.txt folder/
```

Delete

```bash
rm file.txt
```

Create

```bash
touch file.txt
```

---

# Directory Operations

```bash
mkdir folder

rmdir folder

pwd

cd folder

ls
```

---

# Process Management

Current process

```bash
ps
```

All

```bash
ps aux
```

Kill

```bash
kill PID
```

Force

```bash
kill -9 PID
```

Background

```bash
./script.sh &
```

---

# Pipes

```bash
cat users.txt | grep John
```

Output of first command becomes input of second.

---

# Redirection

Overwrite

```bash
echo Hello > file.txt
```

Append

```bash
echo World >> file.txt
```

Input

```bash
sort < file.txt
```

Error

```bash
command 2> error.log
```

Both

```bash
command > output.log 2>&1
```

---

# Command Substitution

Old

```bash
today=`date`
```

Modern

```bash
today=$(date)
```

Always prefer

```bash
$( )
```

---

# Useful Linux Commands

```
grep

find

awk

sed

cut

sort

uniq

wc

head

tail

xargs

tar

gzip

curl

wget

chmod

chown

scp

rsync

```

These are the "superpowers" of Bash.

---

# Scheduling Scripts

Cron

Edit

```bash
crontab -e
```

Every day at midnight

```bash
0 0 * * * /home/user/script.sh
```

Cron format

```
Minute

Hour

Day

Month

Weekday
```

---

# Error Handling

Recommended

```bash
#!/bin/bash

set -e
```

Exit immediately on error.

Safer

```bash
set -euo pipefail
```

Meaning

```
-e Exit on error

-u Undefined variables cause errors

-o pipefail Detect pipeline failures
```

---

# Debugging

Run

```bash
bash -x script.sh
```

or

```bash
set -x
```

Stop debugging

```bash
set +x
```

---

# Quoting

Single

```bash
'$HOME'
```

Output

```
$HOME
```

Double

```bash
"$HOME"
```

Output

```
/home/user
```

---

# Best Practices

✅ Always use

```bash
#!/usr/bin/env bash
```

instead of

```bash
#!/bin/bash
```

for portability.

---

Always

```bash
set -euo pipefail
```

---

Quote variables

Good

```bash
"$file"
```

Bad

```bash
$file
```

---

Use meaningful names

Bad

```bash
a=20
```

Good

```bash
user_age=20
```

---

Use functions

Don't create one giant script.

Split logic.

---

Check errors

Bad

```bash
cp file backup
```

Good

```bash
if cp file backup
then
echo Success
else
echo Failed
fi
```

---

Use ShellCheck

Install

```bash
shellcheck script.sh
```

It catches common Bash mistakes.

---

# Security Best Practices

Never

```bash
rm -rf "$dir"
```

without validating `$dir`.

Avoid

```bash
eval
```

unless absolutely necessary.

Always quote user input.

Never hardcode passwords.

Use environment variables.

Check command success.

Use least privilege.

---

# Real World Examples

## Backup Folder

```bash
#!/bin/bash

tar -czf backup.tar.gz Documents
```

---

## Ping Server

```bash
#!/bin/bash

ping -c 4 google.com
```

---

## Disk Usage

```bash
df -h
```

---

## Find Large Files

```bash
find . -type f -size +100M
```

---

## Rename Files

```bash
for file in *.txt
do
mv "$file" "new_$file"
done
```

---

## Create 100 Files

```bash
for i in {1..100}
do
touch file$i.txt
done
```

---

# Common Mistakes

❌ Forgetting quotes

```bash
$file
```

✔

```bash
"$file"
```

---

❌ Using backticks

```bash
`date`
```

✔

```bash
$(date)
```

---

❌ Ignoring exit codes

Always check

```bash
echo $?
```

---

❌ Running without permissions

```bash
chmod +x script.sh
```

---

# Bash Cheat Sheet

Variables

```bash
name="John"
```

Input

```bash
read name
```

If

```bash
if [ ]
```

Loop

```bash
for

while
```

Function

```bash
function_name(){

}
```

Array

```bash
arr=(1 2 3)
```

Arguments

```
$1

$2

$@

$#
```

Status

```bash
$?
```

Current directory

```bash
pwd
```

Current user

```bash
whoami
```

Current shell

```bash
echo $SHELL
```

---

# Bash Scripting Learning Roadmap

## Beginner

- Linux commands
- Variables
- Input/output
- Conditionals
- Loops
- Functions
- Files

---

## Intermediate

- Arrays
- grep
- sed
- awk
- cron
- pipes
- redirection
- command substitution
- process management

---

## Advanced

- ShellCheck
- Error handling
- Signals and traps (`trap`)
- Background jobs
- Parallel execution
- Logging
- Automation scripts
- Docker automation
- Kubernetes scripts
- AWS CLI automation
- Terraform automation
- CI/CD scripting

---

# Bash in DevOps

Bash is commonly used to:

- Provision infrastructure
- Deploy applications
- Build CI/CD pipelines
- Monitor servers
- Rotate logs
- Backup databases
- Manage Docker containers
- Interact with Kubernetes
- Automate Terraform workflows
- Execute AWS CLI commands
- Automate Linux administration

---

# Interview Questions

1. What is Bash?
2. What is the purpose of a shebang?
3. What is the difference between `$@` and `$*`?
4. What does `$?` represent?
5. Explain `set -euo pipefail`.
6. What is command substitution?
7. Difference between `>` and `>>`?
8. Difference between `[` and `[[`?
9. How do you schedule a Bash script?
10. Why should variables be quoted?
11. What is a pipe (`|`)?
12. What does `chmod +x` do?
13. Explain file test operators (`-f`, `-d`, `-r`, `-w`, `-x`).
14. How do you debug a Bash script?
15. Why is `ShellCheck` recommended?

---

# Final Advice

Bash is not just a scripting language—it's a core automation tool for Linux and cloud environments. Mastering Bash will make you significantly more productive in DevOps, Cloud Engineering, Backend Development, and System Administration.

Focus on writing small, modular, readable scripts, always validate input, handle errors properly, and automate repetitive tasks whenever possible. The more real-world problems you solve with Bash, the more natural it becomes.