#!/bin/bash
nmap -sV --script vulners $1 -p 80,443
