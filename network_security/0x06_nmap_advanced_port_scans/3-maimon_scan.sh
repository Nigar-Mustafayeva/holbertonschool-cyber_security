#!/bin/bash
sudo nmap -sM "$1" -p 20-444 -vv --reason --open
