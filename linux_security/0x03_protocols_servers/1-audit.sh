#!/bin/bash
grep -E "^(Port|PermitRootLogin|PasswordAuthentication|AllowUsers|AllowGroups)" /etc/ssh/sshd_config; sudo ss -tulpn | grep ssh
