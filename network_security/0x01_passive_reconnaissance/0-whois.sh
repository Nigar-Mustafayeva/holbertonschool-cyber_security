#!/bin/bash
whois "$1" | awk ' Begin { section ='Registrant', section ='Admin' section ='Tech' }' 
