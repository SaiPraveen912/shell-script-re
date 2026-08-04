#!/bin/bash

COURSE="DevOps from current script"

echo "Before calling other script, course: $COURSE"
echo "Process ID of current shell script: $$"

#./18-other-script.sh

echo "After calling other script, course: $COURSE"
echo "Process ID of current shell script: $$"