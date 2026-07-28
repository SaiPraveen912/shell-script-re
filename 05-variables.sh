#!/bin/bash

echo "Please enter username:"

read -s USERNAME #here USERNAME is variable

echo "Please enter password"

read -s PASSWORD # -s while typing in command line the details are not visible

echo "Username is: $USERNAME, Password is: $PASSWORD"