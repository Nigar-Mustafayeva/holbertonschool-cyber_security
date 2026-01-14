#!/bin/bash
curl -v -X POST "$1" -H "$2" -d "$3"
