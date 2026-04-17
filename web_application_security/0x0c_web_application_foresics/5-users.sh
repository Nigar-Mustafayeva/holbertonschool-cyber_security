#!/usr/bin/env bash
grep -E "useradd|adduser|new user|account" auth.log | awk -F"'" '{print $2}' | sort -u | paste -sd,
