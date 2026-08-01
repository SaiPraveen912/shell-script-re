#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log

echo $SCRIPT_NAME
echo $LOGFILE
echo $TIMESTAMP

if [ $USERID -ne 0 ]
then
    echo "Please run the script using super user credentials"
    exit 1
else
    echo "You are super user"
fi

echo "Is script proceeding?"