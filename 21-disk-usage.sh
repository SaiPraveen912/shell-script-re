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
        MESSAGE="$FOLDER is more than $DISK_THRESHOLD, current usage: $USAGE"
    fi
done <<< $DISK_USAGE

echo "Message: $MESSAGE"