#!/bin/bash

DEVICE_1=$(xinput list | grep "ASUS Base Station" | grep pointer | tail -n1 | sed -nr "s|.*$1.*id=([0-9]+).*|\1|p")
DEVICE_2=$(xinput list | grep "ASUS Base Station" | grep pointer | head -n1 | sed -nr "s|.*$1.*id=([0-9]+).*|\1|p")


TOGGLE=/tmp/toggle_touch

if [ ! -e $TOGGLE ]; then
    touch $TOGGLE
    
    xinput disable $DEVICE_1
    xinput disable $DEVICE_2

    
else
    rm $TOGGLE
    
    xinput enable $DEVICE_1
    xinput enable $DEVICE_2
    
fi


