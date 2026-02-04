#!/bin/bash
hashcat -m 0 -a 1 hash.txt "$1" "$2"
