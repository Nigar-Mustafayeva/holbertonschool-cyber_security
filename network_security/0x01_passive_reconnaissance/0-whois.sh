#!/bin/bash
whois $1 | awk -F': ' '/^(Registrant|Admin|Tech) (Name|Organization|Street|City|State\/Province|Postal Code|Country|Phone|Phone Ext|Email):/{f=$1; v=$2; if(f~/Street$/) v=v" "; if(f~/Ext$/) f=f":"; sub(/:$/,"",f); printf "%s,%s\n", f, v}'
