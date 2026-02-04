#!/bin/bash
john --format=raw-md5 --wordlist=/usr/share/wordlists/rockyou.txt "$1" | john --show --format=raw-md5 hash.txt | cut -d':' -f2 > 4-password.txt 
