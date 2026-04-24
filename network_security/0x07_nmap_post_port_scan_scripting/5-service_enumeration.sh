#!/bin/bash
nmap -A --script "banner,vulners" "ssl-vuln* smb-vuln*" -oN service_enumeration_results.txt
