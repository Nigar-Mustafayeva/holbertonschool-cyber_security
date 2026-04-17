#!/usr/bin/env bash
grep '" 200 ' auth.log | awk '{print $1}' | sort -u | wc -l
