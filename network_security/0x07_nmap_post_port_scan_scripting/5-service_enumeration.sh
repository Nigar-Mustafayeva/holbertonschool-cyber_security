#!/bin/bash
nmap -sV -O -sC --script "banner,vulners" "ssl-vuln* smb-vuln*" --traceroute -oN service_enumeration_results.txt
