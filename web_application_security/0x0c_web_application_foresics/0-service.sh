#!/bin/bash
grep -o 'sshd[^ ]*' /var/log/auth.log | sort | uniq -c | sort -nr
