#!/bin/bash
sudo nmap -sT "$1" -p "$2" -oA custom_scan.txt
