#!/bin/bash

USERID=$(id -u)

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo "$2...FAILURE"
        exit 1
    else 
        echo "$2...SUCCESS"
    fi
}

if [ $USERID -ne 0 ]
then
    echo "Please run this script with root access"
    exit 1 # Manually exit if error comes We can use 1 to 127 --> 0 is for success exit status
else
    echo "You are super user"
fi

dnf install mysql -y    # -y is mandatory otherwise shell script will keep on waiting
VALIDATE $? "Installing MySQL"

dnf install git -y
VALIDATE $? "Installing Git"

echo "Is script proceeding?"