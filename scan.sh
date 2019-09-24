#!/bin/bash
#
#run as ROOT
#required: nmap, arp-scan
#syntax: scan /dir target

SCAN_DIR=$1
cd $SCAN_DIR

echo Scanning with nmap...
nmap -sn $2 | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}" > hosts.nmap
echo Scanning with arp-scan...
arp-scan -l | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}" > hosts.arp
echo
sort -n hosts.nmap hosts.arp | uniq | sort -n | tee hosts.lst
rm hosts.nmap hosts.arp

exit
