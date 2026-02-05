#!/bin/bash 
find "$1" -perm 4000 -o 2000 -type f -empty -exec ls -l {} \; | sudo chmod -R 777 "$1"
