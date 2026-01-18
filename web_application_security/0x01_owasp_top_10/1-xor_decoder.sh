#!/bin/bash

# Check if the argument is provided
if [ -z "$1" ]; then
    echo "Usage: $0 {xor}HASH"
    exit 1
fi

# Remove the "{xor}" prefix from the input string
encoded_string="${1#\{xor\}}"

# Decode from Base64 and XOR each byte with '_' (ASCII 95)
echo -n "$encoded_string" | base64 -d 2>/dev/null | perl -pe '$_ ^= "_" x length'
echo ""  # Add newline for clean output
