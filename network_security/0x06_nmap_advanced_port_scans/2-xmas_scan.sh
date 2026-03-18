#!/bin/bash
sudo nmap -sX "$1" -packet-trace -reason
