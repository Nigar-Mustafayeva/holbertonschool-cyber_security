#!/bin/bash
sudo nmap -sM "$1" -p21,22,23,80,443 -vv
