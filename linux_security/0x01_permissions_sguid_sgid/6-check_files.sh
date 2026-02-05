#!/bin/bash
find "$1" -mtime -1 -perm 2000 or 4000 -type f 2>/dev/null
