#!/bin/bash

MOVIES=("RRR" "DJTillu" "Murari") #list of movies

# list always start with 0
# Size of above array is 3
# index are 0,1,2
# index is always -1 of the size of the array

echo "First Movie is: ${MOVIES[0]}"
echo "Second Movie is: ${MOVIES[1]}"
echo "Third Movie is: ${MOVIES[2]}"
echo "All movies is: ${MOVIES[@]}"