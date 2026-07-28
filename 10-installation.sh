#!/bin/bash

USERID=$(id -u)

if [ $USERID -ne 0 ]
then
    echo "Please run this script with root access"
    exit 1 # Manually exit if error comes We can use 1 to 127 --> 0 is for success exit status
else
    echo "You are super user"
fi

dnf install mysql -y    # -y is mandatory otherwise shell script will keep on waiting


if [ $? -ne 0 ]
then
    echo "Installation of mysql...FAILURE"
    exit 1
else 
    echo "Installation of mysql...SUCCESS"
fi

dnf install git -y

if [ $? -ne 0 ]
then
    echo "Installation of git...FAILURE"
    exit 1
else 
    echo "Installation of git...SUCCESS"
fi

echo "Is script proceeding?"