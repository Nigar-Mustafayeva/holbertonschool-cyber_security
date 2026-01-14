#!/bin/bash
curl -s -X POST -H "Host: $1" -d "$2" "$3"
