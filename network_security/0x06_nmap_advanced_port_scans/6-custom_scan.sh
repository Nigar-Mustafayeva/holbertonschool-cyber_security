#!/bin/bash
sudo nmap --scanflags 0x3F -p "$2" "$1" -oN custom_scan.txt > /dev/null 2>&1
