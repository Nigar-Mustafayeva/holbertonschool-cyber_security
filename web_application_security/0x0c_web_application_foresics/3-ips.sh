#!/bin/bash

if [ -z $1 ]
then
    echo "Usage: $0 auth.log"
    exit 1
fi

grep "Accepted" $1 | awk '{print $11}' | sort -u | wc -l
