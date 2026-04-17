#!/bin/bash
cat $1 | grep "Accepted" | grep -oE "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+" | sort -u | wc -l
