#!/bin/bash

# made this for the 4.7rc4 kernel, wlan lossing bug, should work 98% of the time

dmesgError=$(dmesg | grep  "wlan0: link is not ready" | tail -n 1| cut -d']' -f1 | cut -c3-| tr -d '.')
#echo "basic $dmesgError"

while [ 1 ]
do
dmesgError2=$(dmesg | grep  "wlan0: link is not ready" | tail -n 1| cut -d']' -f1 | cut -c3-| tr -d '.')
#echo "now $dmesgError2"
#echo "old $dmesgError"

nmcli g | grep none
if [ $? -eq 0 ]; then
	# we are disconnected
	if [ $dmesgError2 -ne $dmesgError ]; then
	# timestamp different
	notify-send -i notification-device-eject Wifi "Restarting.."
        sudo rmmod brcmfmac
        sudo modprobe brcmfmac
	
	#echo "new basic $dmesgError"
	
	#echo "do it"
	sleep 8
        dmesgError2=$(dmesg | grep  "wlan0: link is not ready" | tail -n 1| cut -d']' -f1 | cut -c3-| tr -d '.')
	dmesgError=$dmesgError2
	
        #else
	# timestamp ident do nothing
	#echo "timestamp is the same you probably disconnected yourself?"
	#echo "$dmesgError $dmesgError2"
        fi
#else


#echo "we are conected"

fi

sleep 1
done
