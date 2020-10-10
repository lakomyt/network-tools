#!/bin/bash
#
#run as ROOT
#required: nmap, arp-scan
#syntax: scan /dir target

SCAN_DIR=$1
TARGET=$2

cd $SCAN_DIR

scan(){
	echo Scanning with nmap...
	nmap -sn $TARGET | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}" > hosts.nmap
	echo Scanning with arp-scan...
	arp-scan -l | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}" > hosts.arp
	echo DONE.
	sort -n hosts.nmap hosts.arp | uniq | sort -t . -k 3,3n -k 4,4n | tee $1
	rm hosts.nmap hosts.arp
	cat $1 | grep "`ip route get 1.1.1.1 | head -1 | awk '{print $7}'`" -v > $1
}

scan hosts.lst

while [ 1 == 1 ]; do
	sleep 1200
	scan NEW_hosts.lst
	diff hosts.lst NEW_hosts.lst | grep ">" > /dev/null
	if [ $? -eq 1 ]; then
		date +%H:%M_%e-%m-%Y >> hosts.dif
		diff hosts.lst NEW_hosts.lst | tee -a hosts.dif | grep ">" | sed 's/> //' | tee -a hosts.lst
		sort -t . -k 3,3n -k 4,4n hosts.lst | uniq > hosts.lst2
		cat hosts.lst2 > hosts.lst
		rm hosts.lst2
	fi
	rm NEW_hosts.lst
done

exit
