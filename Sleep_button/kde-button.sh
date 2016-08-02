#!/bin/bash

SCRENN="ON"

while [ 1 ]
do

#get tablet status
if [ -d /dev/input/by-id ]; then
	BSTATE3="DOCKED"
	#echo "docked-boot" > /tmp/docked-boot
else
	BSTATE3="UNDOCKED" 
	#echo "undocked-boot" > /tmp/undocked-boot
fi

#SCRENN="ON"

echo "pre event"
echo $BSTATE3

button=$(acpi_listen -c 1)

echo "post event"
sleep 0.6

if [ -d /dev/input/by-id ]; then
	BSTATE2="DOCKED"
	#echo "docked-boot" > /tmp/docked-boot
else
	BSTATE2="UNDOCKED" 
	#echo "undocked-boot" > /tmp/undocked-boot
fi

echo $BSTATE2

if [ $BSTATE2 == $BSTATE3 ]; then

# echo $BSTATE2 >> /tmp/TEST
# 
# echo $BSTATE3 >> /tmp/TEST

echo "do it only now"

echo $button | grep PNP0C14

if [ $? -eq 0 ]; then
    #xdotool key ctrl+F8
    #echo ""
    #echo "trest"
    
    # clascic windows feat: turn of screen WARNING: does not turn of with touchscreen
    #xset dpms force off
if [ -d /dev/input/by-id ]; then
	#BSTATE2="DOCKED"
	xdotool key --clearmodifiers ctrl+F8
	#echo "docked-boot" > /tmp/docked-boot
else
	
	if [ "$SCRENN" == "ON" ]; then
	
	echo "screen on turn off"
	
	SCRENN="OFF" 
	xinput disable 13
	xset dpms force off
	xset +dpms 
	
	#echo "undocked-boot" > /tmp/undocked-boot
	else
	echo "screen off turn on"
	SCRENN="ON" 
	xinput enable 13
	xset dpms force on
	#xinput enable 13
	xset +dpms
	fi
	
fi
    
    
    #xdotool key --clearmodifiers ctrl+F8
    #sleep 0.5
fi
else
 echo "und/ocking dont do the action"



fi




done