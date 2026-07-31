#!/bin/bash

USERID=$(id -u)

if [ $USERID -ne 0 ]
then
    echo "Please run the script using root access"
    exit 1 # Manually exit if error comes
else
    echo "You are super user"
fi

echo "All packages: $@"