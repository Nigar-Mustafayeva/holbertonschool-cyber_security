#!/bin/bash
nmap -sV -A --script vulners "banner,ssl-enum-ciphers,default,smb-enum-domains" $1 -oN service_enumeration_results.txt
