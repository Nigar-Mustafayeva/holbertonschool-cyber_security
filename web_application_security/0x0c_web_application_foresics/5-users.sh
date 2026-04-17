#!/bin/bash
grep "useradd" auth.log | awk '{print $8}' | sort -u | paste -sd,
