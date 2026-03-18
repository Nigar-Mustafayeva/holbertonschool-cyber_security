#!/bin/bash
sudo nmap -sX "$1" --open --packet-trace --reason
