#!/bin/bash
echo -n "$1"$(openssl rand -base64 16) | openssl sha512 > 3_hash.txt
