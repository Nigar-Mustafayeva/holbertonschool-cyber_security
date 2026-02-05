#!/bin/bash
find "$1" -perm 4000 -o 2000 -type f 2>/dev/null -exec ls -l {} \; | sudo chmod -R o=r "$1"
