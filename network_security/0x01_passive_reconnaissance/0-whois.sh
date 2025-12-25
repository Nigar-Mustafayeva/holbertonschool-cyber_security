#!/bin/bash
whois "$1" | awk -F': ' 'index($1,"Registrant")==1||index($1,"Admin")==1||index($1,"Tech")==1{split($1,a," ");r=a[1];f=substr($1,length(r)+2);v=$2;if(index(f,"Street"))v=v" ";if(index(f,"Phone Ext")||index(f,"Fax Ext"))printf "%s %s;n",r,f,v;else printf "%s %s,%s\n",r,f,v}' > "$1.csv"
