#!/bin/bash
whois "$1" | awk ' Begin { section ='' }'
