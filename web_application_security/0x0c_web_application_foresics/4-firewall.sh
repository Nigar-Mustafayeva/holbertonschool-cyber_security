#!/bin/bash
grep -F "iptables" $1 | wc -l
