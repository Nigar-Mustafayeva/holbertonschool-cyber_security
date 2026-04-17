#!/usr/bin/env bash
grep -o 'sshd[^ ]*' auth.log | sort | uniq -c | sort -nr
