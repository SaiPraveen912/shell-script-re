#!/bin/bash

MEMORY_USAGE=$(free | grep Mem | awk '{print ($3/$2)*100}')
MEMORY_THRESHOLD=25

echo "Current Memory Usage: $MEMORY_USAGE%"

if [ ${MEMORY_USAGE%.*} -ge $MEMORY_THRESHOLD ]
then
    MESSAGE="High Memory Usage on server: Current usage is ${MEMORY_USAGE}%"

    echo "$MESSAGE"

    printf '%b' "$MESSAGE" | mail -s "Memory Usage Alert" saipraveen.immanni@gmail.com
fi