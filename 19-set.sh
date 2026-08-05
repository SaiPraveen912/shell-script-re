#!/bin/bash

set -e

USERID=$(id -u)

if [ $USERID -ne 0 ]
then
    echo "Please run this script with root access"
    exit 1 # Manually exit if error comes We can use 1 to 127 --> 0 is for success exit status
else
    echo "You are super user"
fi

dnf install mysqsdcdsl -y    # -y is mandatory otherwise shell script will keep on waiting
dnf install git -y


echo "Is script proceeding?"