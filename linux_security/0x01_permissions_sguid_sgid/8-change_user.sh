#!/bin/bash
find "$1" -perm 2000 -o 4000 -type f 2>/dev/null -exec ls -l {} \; | sudo chown -R user3 "$1"
