#!/bin/bash
sudo nmap -sM -p21-23,80,443 -vv $1
