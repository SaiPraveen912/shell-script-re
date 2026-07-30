#!/bin/bash

USERID=$(id -u)

if [ $USERID -ne 0 ]
then
    echo "Please run the script using root user credentials"
else
    echo "You are super user"
fi

dnf install mysql -y

if [ $? -ne 0 ]
then 
    echo "Installing MySQL...FAILURE"
else
    echo "Installing MySQL...SUCCESS"
fi

dnf install git -y

if [ $? -ne 0 ]
then
    echo "Installing Git...FAILURE"
else
    echo "Installing Git...SUCCESS"
fi

echo "Is script proceeding?"