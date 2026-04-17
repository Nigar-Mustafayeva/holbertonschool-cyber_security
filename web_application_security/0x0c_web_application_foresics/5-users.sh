#!/bin/bash
grep "useradd" auth.log | sed 's/.*name=//' | cut -d',' -f1 | sort -u | paste -sd,
