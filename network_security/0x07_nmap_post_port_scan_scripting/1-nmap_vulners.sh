#!/bin/bash
nmap --script vulners $1 -p80,443
