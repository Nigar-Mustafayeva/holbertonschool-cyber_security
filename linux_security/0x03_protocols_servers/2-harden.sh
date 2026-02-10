#!/bin/bash
find / -perm 0002 -type d -exec chmod o-w {} \;
