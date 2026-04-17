#!/usr/bin/env bash
grep "sshd" auth.log | grep -E "Accepted password|Failed password" | awk '{for(i=1;i<=NF;i++) if($i=="for"){if($(i+1)!="invalid") print $(i+1)}}' | sort -u | paste -sd,
