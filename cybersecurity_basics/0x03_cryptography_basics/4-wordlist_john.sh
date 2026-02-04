#!/bin/bash
john --format=raw-md5 --wordlist=/usr/share/wordlists/rockyou.txt $1 > 4-password.txt
