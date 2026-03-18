#!/bin/bash
sudo nmap -sM "$1" -p 80,443,21,22,23 -vv
