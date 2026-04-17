#!/bin/bash
grep -i "iptables\|ufw\|firewall" $1 | wc -l
