#!/bin/bash
whois $1 | awk '/(Registrant|Admin|Tech)/ && /:/{f=$1" "$2; sub(/^[^:]+:[ \t]*/,""); if(f~/Street$/) $0=$0" "; if(f~/Ext$/) f=f":"; printf "%s,%s\n", f, $0}'
