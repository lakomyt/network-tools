#!/bin/bash
#
#run as ROOT
#required: nmap, arp-scan
#syntax: deepscan /dir file-with-hosts-list

SCAN_DIR=$1
cd $SCAN_DIR

if [ ! -e hosts ];then
	mkdir hosts
fi

while read host; do
	if [ ! -e hosts/$host  ];then
		nmap -Pn -A -T4 -sS -sV -p- --script vuln $host | tee hosts/$host
	fi
done < $2

exit
