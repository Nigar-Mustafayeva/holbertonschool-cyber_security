#!/bin/bash
whois "$1" | awk -F': ' '/^(Registrant|Admin|Tech)/{k=$1;sub(/^[^ ]+ /,"",k);v=$2;if(k~/Street/)v=v" ";if(k~/Phone Ext|Fax Ext/)printf "%s %s:,%s\n",$1,k,v;else printf "%s %s,%s\n",$1,k,v}'
