#!/bin/sh

sleep 2

if [ -d /dev/input/by-id ]; then
	BSTATE="DOCKED"
	
	dockedboot="yes"
	#echo "docked-boot" > /tmp/docked-boot
else
	BSTATE="UNDOCKED" 
	dockedboot="no"
	#echo "undocked-boot" > /tmp/undocked-boot
fi

while true
do
	if [ -d /dev/input/by-id ]; then
		if [ $BSTATE = "UNDOCKED" ]; then
			BSTATE="DOCKED"
			notify-send -i notification-device-connect Tablet "Docked"
			killall onboard
		fi

	else
		if [ $BSTATE = "DOCKED" ]; then
			BSTATE="UNDOCKED"
			notify-send -i notification-device-eject Tablet "Undocked"
			onboard &
		fi
		if [ $BSTATE = "UNDOCKED" ] && [ $dockedboot = "no" ]; then
			BSTATE="UNDOCKED"
			#rm /tmp/undocked-boot
			notify-send -i notification-device-eject Tablet "Undocked"
			dockedboot=""
			onboard &
			
		fi
		
	fi

    sleep 1
done
