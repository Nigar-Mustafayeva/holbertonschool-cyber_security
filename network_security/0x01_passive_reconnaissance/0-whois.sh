#!/bin/bash
whois "$1" | awk ' section != "" && /Name:/ {    printf "%s Name,%s\n", section, substr($0, index($0, ":")+2) } '
