#!/bin/bash
ps aux | grep -v "VSZ|RSS" -f "$1"  
