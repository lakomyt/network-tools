#!/bin/bash
#
#run as ROOT
#required: nmap, arp-scan
#syntax: deepscan /dir file-with-hosts

SCAN_DIR=$1
cd $SCAN_DIR

if [ ! -e hosts ];then
	mkdir hosts
fi

while read host; do
	if [ ! -e hosts/$host  ];then
		nmap -Pn -A -T4 --top-ports 10000 $host | tee hosts/$host
	fi
done < $2

exit