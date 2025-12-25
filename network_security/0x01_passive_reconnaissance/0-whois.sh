#!/bin/bash
whois "$1" | awk '$1=="Registrant"' ; awk '$1=="Admin"' ; awk '$1=="Tech"' 
