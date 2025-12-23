#!/bin/bash
sudo iptables -A INPUT -p tcp --dport80 -j ACCEPT
