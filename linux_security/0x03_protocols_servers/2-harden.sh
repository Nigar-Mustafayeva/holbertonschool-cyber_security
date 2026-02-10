#!/bin/bash
find / -xdev -perm 0002 -type d -exec chmod o-w {} \;
