#!/bin/bash
grep "Accepted" $1 | awk '{print $11}' | sort -u | wc -l
