#!/bin/bash

if [ -z "$USER" ]
then
	echo "No user was set. Use -u=username"
	exit 10
fi

if [ -z "$PASSWORD" ]
then
	echo "No password was set. Use -p=password"
	exit 20
fi

if [ ! -s "/config/hostsList.txt" ]
then
	echo "No host name. Paste hostnames to /config/hostsList.txt. One per line"
	exit 40
fi

if [ -n "$DETECTIP" ]
then
	IP=$(wget -qO- "https://ip.d-pelz.de")
fi

if [ -n "$DETECTIP" ] && [ -z $IP ]
then
	RESULT="Could not detect external IP."
fi

if [[ $INTERVAL != [0-9]* ]]
then
	echo "Interval is not an integer."
	exit 35
fi

if [ ! -z "$TZ" ]
then
       ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
fi

timestamp() {
	date
}

LASTIP=""

> /log/ddns.log

while :
do
	if [ -n "$DETECTIP" ]
	then
		IP=$(wget -qO- "https://ip.d-pelz.de")
	fi

	if [ -n "$DETECTIP" ] && [ -z $IP ]
	then
		RESULT="Could not detect external IP."
		echo "[$(timestamp)]: $RESULT" | tee -a /log/ddns.log
	else
		if [ "$LASTIP" != "$IP" ]; then
			while read hostname
			do
				HOSTNAME="$hostname"
				RESULT=$(wget -qO- https://api.org-dns.com/dyndns/?user=$USER\&key=$PASSWORD\&domain=$HOSTNAME)
				echo "[$(timestamp)]: $RESULT ($IP) ($HOSTNAME)" | tee -a /log/ddns.log
			done < "/config/hostsList.txt"
		else
			RESULT="IP unchanged, not updated ($IP)"
			echo "[$(timestamp)]: $RESULT" | tee -a /log/ddns.log
		fi
	fi

	LASTIP="$IP"

	if [ $INTERVAL -eq 0 ]
	then
		break
	else
		sleep "${INTERVAL}m"
	fi

done

exit 0
