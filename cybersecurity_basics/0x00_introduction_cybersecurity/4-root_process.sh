#!/bin/bash

# Check if username was provided
if [ -z "$1" ]; then
    echo "Usage: $0 <username>"
    exit 1
fi

# Monitor processes of the user, excluding VSZ or RSS equal to 0
ps -u "$1" -o user,pid,%cpu,%mem,vsz,rss,tty,stat,start,time,cmd --no-headers | grep -v -E '\s0\s0\s'
