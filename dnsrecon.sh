#!/bin/bash
#Modo de uso:
#./dnsrecon.sh www.exemplo.com wordlist.txt


for sub in $(cat "$2"); do
    host "$sub.$1" | grep -v "NXDOMAIN"
done

