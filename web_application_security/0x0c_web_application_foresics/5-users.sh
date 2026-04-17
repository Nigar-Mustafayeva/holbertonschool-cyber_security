#!/usr/bin/env bash
grep -E "Failed password|Accepted password" auth.log | awk '{for(i=1;i<=NF;i++) if($i=="for"){if($(i+1)=="invalid") print $(i+3); else print $(i+1)}}' | sort -u | paste -sd,
