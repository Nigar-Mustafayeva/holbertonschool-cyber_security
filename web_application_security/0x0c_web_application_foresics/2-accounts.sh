#!/usr/bin/env bash
tail -1000 auth.log | grep -E "Failed password|Accepted password" | awk '{print $(NF)}' | sort | uniq -c | sort -nr | head -1 | awk '{print $2}'
