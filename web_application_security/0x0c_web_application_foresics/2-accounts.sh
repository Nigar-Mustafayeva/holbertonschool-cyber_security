#!/usr/bin/env bash
tail -1000 auth.log | grep -E "Failed password for|Accepted password for" | awk '{for(i=1;i<=NF;i++) if($i=="for") print $(i+1)}' | sort | uniq -c | sort -nr | head -1 | awk '{print $2}'
