#!/bin/bash
sudo addgroup "$1"
sudo chown $whoami:"$1" "$2"
sudo chmod g=r,x "$2"
