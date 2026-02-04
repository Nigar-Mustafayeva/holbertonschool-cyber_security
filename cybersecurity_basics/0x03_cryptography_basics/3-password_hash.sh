#!/bin/bash
echo -n "$1"$(openssl rand -base64 16) | openssl sha256 > 3_hash.txt
