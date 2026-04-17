#!/bin/bash
awk '/Accepted/ {print $11}' $1 | sort -u | wc -l
