#!/bin/bash
nmap -sV -A --script "banner,vulners" "ssl-enum-ciphers smb-enum-domains" -oN service_enumeration_results.txt
