#!/bin/bash 
find "$1" -perm 4000 -o 2000 -type f -empty | sudo chmod -R 777 "$1"
