#!/usr/bin/env bash
grep -i "iptables.*ADD\|iptables.*INSERT\|ufw.*allow" auth.log | wc -l
