#!/bin/bash

USERID=$(id -u)

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo "$2...FAILURE"
    else
        echo "$2...SUCCESS"
}

if [ $USERID -ne 0 ]
then
    echo "Please run the script using super user credentials"
    exit 1
else 
    echo "You are super user"
fi    

dnf install mysql -y
VALIDATE $? "Installing MySQL"

dnf install git -y
VALIDATE $? "Installing Git"

echo "Is script proceeding?"