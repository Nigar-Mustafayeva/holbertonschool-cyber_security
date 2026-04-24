#!/bin/bash
nmap -sV --script vulners $1 -p80,443
