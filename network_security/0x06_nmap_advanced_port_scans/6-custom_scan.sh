#!/bin/bash
sudo nmap $1 -p $2 --scanflags URGACKPSHRSTSYNFIN -oN custom_scan.txt > /dev/null 2>&1
