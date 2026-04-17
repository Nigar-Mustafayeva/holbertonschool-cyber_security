#!/usr/bin/env bash
grep "Accepted password" auth.log | awk '{print $(NF-3)}' | sort | uniq | wc -l
