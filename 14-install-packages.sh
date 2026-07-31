#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo "Insatlling $2...FAILURE"
        exit 1
    else
        echo "Installing $2...SUCCESS"
    fi
}


if [ $USERID -ne 0 ]
then
    echo "Please run the script using root access"
    exit 1 # Manually exit if error comes
else
    echo "You are super user"
fi


for i in $@
do
    echo "Package to install: $i"
    dnf list installed $i &>>$LOGFILE
    if [ $? -eq 0 ]
    then
        echo "$i already installed...SKIPPING"
    else
        echo "$i not installed...Need to install"
    fi
done