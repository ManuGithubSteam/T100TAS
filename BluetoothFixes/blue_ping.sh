#!/bin/bash

/usr/local/libexec/bluetooth/obexd &

DEVICE_1=DC:2C:26:F9:7C:1D

MOUSE=0

while [ 1 ]
do

# mouse
if [ $MOUSE -eq 0 ]; then
#echo "trest"
hcitool con | grep $DEVICE_1
if [ $? -eq 0 ]; then

MOUSE=1
# mac of bt mouse 
sudo l2ping $DEVICE_1 -d 7 &
#echo "now"
fi
fi

sleep 2

done