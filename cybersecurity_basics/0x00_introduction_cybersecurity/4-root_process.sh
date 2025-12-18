#!/bin/bash
ps aux | grep -v "VSZ|RSS" "$1"  
