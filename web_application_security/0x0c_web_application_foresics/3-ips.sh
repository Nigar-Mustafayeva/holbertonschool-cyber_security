#!/bin/bash
awk '/Accepted/ {print $0}' auth.log | head
