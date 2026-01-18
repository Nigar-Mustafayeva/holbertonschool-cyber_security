#!/bin/bash
echo "$1" | sed 's/{xor}//' | base64 -d | od -An -tu1 | tr -s ' ' '\n' | while read n; do printf "\\$(printf '%03o' $((n^42)))"; done
