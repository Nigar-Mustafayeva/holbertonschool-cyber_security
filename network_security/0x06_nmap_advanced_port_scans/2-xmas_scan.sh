#!/bin/bash
sudo nmap -sX "$1" -p- --packet-trace --reason --open
