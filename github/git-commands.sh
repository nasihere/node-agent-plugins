#!/bin/bash

CUR_DIR=$(pwd)
#echo $CUR_DIR
# remove branch list report file
REPORT_FILE=$CUR_DIR/branchlist_branch
REPORT_REMOTE=$CUR_DIR/branchlist_remote
REPORT=$CUR_DIR/git-commands.json

DEFAULT_COMMAND='master';
rm $REPORT_FILE $REPORT_REMOTE; 

# store the current dir
CUR_DIR=/Users/sayedn/projects/ceh/id-ceh-reactui

# Let the person running the script know what's going on.
#echo "\n\033[1mFectching latest \033[0m\n"

# We have to go to the .git parent directory to call the pull command
cd "$CUR_DIR";

# finally pull all the branch 
DEFAULT_COMMAND=$(git branch | grep '*' | sed 's/* //g');
git branch | sed 's,^ *,,; s, *$,,' >> $REPORT_FILE;
git remote -v >> $REPORT_REMOTE; 


#echo "\n\033[32mComplete!\033[0m\n"

# cat $REPORT_FILE;
# cat $REPORT_REMOTE;

gitCmd=""
IFS=$'\n'; 
for line in $(cat $REPORT_FILE); 
do 
    gitCmd+="$line\n"; 
done
echo $gitCmd > $REPORT_FILE;
printf "{"

    printf "title: 'CURRENT $DEFAULT_COMMAND BRANCH',"
    printf "default: 'git pull origin $DEFAULT_COMMAND',"

    loopStarted=false
    printf "data: ["
    for line in $(cat $REPORT_FILE); 
    do 
        if [ "$loopStarted" = true ] ; then
            printf ","
        fi
        loopStarted=true;
        printf "{"
            printf "item: '$line', "; 
            printf "command: 'git pull origin $line'"; 
        printf "}"
    done
    printf "]"
printf "}"
echo 