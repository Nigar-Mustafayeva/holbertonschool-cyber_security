#!/bin/bash
echo "$1" | sed 's/{xor}//' | base64 -d | xxd -p | sed 's/../0x& /g' | awk '{for(i=1;i<=NF;i++) printf "%c", strtonum($i)^42} END{print ""}'
