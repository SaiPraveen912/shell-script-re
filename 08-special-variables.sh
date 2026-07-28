#!/bin/bash

echo "All variables: $@" # @ is notation of everything
echo "Number of variables passed: $#" # # is the notation of number of values passed
echo "To know this Script Name: $0"
echo "To know current working directory: $PWD"
echo "Home directory of current user: $HOME"
echo "Which user is running this script: $USER" 
echo "Hostname: $HOSTNAME"
echo "Process ID of current shell script: $$"