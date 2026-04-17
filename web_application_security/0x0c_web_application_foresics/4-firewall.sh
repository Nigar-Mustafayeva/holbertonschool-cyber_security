#!/bin/bash
awk '/iptables/{c++}END{print c}' $1
