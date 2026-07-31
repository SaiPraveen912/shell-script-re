#!/bin/bash

USERID=$(id -u)

if [ $USERID -ne 0 ]
then
    echo "Please run the script using root user credentials"
    exit 1
else
    echo "You are root user"
fi

echo "Is script proceeding?"
echo "All packages: $@"