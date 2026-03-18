#!/bin/bash
sudo nmap -sX "$1" --packet-trace --reason -oA open|filtered
