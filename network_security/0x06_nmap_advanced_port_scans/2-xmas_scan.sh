#!/bin/bash
sudo nmap -sX "$1" -p80 --packet-trace --reason --open
