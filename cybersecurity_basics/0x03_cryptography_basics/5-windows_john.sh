#!/bin/bash
john --format=nt --wordlist=/usr/share/wordlists/rockyou.txt "$1" | john --show --format=nt hash2.txt | cut -d':' -f2 > 5-password.txt
