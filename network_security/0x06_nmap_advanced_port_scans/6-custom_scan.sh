#!/bin/bash
sudo nmap --scanflags URGACKPSHRSTSYNFIN -p 80-90 "$1" -oN custom_scan.txt > /dev/null 2>&1
