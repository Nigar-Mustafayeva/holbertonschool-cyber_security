#!/bin/bash
echo "$1 ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/$1 >/dev/null && sudo chmod 440 /etc/sudoers.d/$1
