#!/bin/bash

USERID=$(id -u)

if [ $USERID -ne 0 ]
then
    echo "Please run the script using super user credentials"
    exit 1
else 
    echo "You are super user"
fi    

echo "Is script proceeding?"