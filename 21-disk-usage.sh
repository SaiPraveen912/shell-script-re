#!/bin/bash

DISK_USAGE=$(df -hT | grep xfs)
DISK_THRESHOLD=6 # Generally this value will be 75 to 80
MESSAGE=""

while IFS= read -r line
do
    USAGE=$(echo $line | awk -F " " '{print $6F}' | cut -d "%" -f1) # To find disk usage in number by removing %
    FOLDER=$(echo $line | awk -F " " '{print $NF}') # To find which file
    if [ $USAGE -ge $DISK_THRESHOLD ]
    then
        MESSAGE+="$FOLDER is more than $DISK_THRESHOLD, current usage: $USAGE \n" # MESSAGE+= is used to append the new values without overriding old values with new values
    fi
done <<< $DISK_USAGE

echo -e "Message: $MESSAGE" # \n is for new line above and -e is to enable special characters for \n to work