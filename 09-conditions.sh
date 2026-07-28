#!/bin/bash

NUMBER=$1

if [ $NUMBER -gt 10 ] # -gt is greater than -lt is less than 
then
    echo "Given number $NUMBER is greater than 10"
else
    echo "Given number $NUMBER is less than 10"
fi

# -gt, -lt, -eq, -ge, -le