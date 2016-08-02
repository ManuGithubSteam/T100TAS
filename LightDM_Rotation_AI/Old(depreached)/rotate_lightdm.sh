#!/bin/bash

# Based on an original by Maxwell Pray (synthead), from
# https://bbs.archlinux.org/viewtopic.php?id=107167

# edited for KDE rotation by me

pointers="$(xinput list)"
xinputs=( 9 8 10 11  )
PID=$$
echo $PID > /tmp/rotate_lightdm_pid

while true
do
    
    xrandrout="$(xrandr)"
    x=$(cat /sys/bus/iio/devices/iio\:device1/in_accel_x_raw)
    y=$(cat /sys/bus/iio/devices/iio\:device1/in_accel_y_raw)
    z=$(cat /sys/bus/iio/devices/iio\:device1/in_accel_z_raw)

    rotate=0

    if [ $x -le 0 ]
    then
	case $x in
	    -???? ) rotate=0;;
	    -????? ) rotate=3;;
	esac
    fi

    if [ $x -ge 0 ]
    then
	case $x in
	    ???? ) rotate=0;;
	    ????? ) rotate=1;;
	esac
    fi

    if [ $rotate = 0 ]
    then
	case $y in
	    -????? ) rotate=2;;
	esac
    fi

    lrotate=$(echo $xrandrout | grep "left (")
    rrotate=$(echo $xrandrout | grep "right (")
    irotate=$(echo $xrandrout | grep "inverted (")

    if [ "$lrotate" != '' ]
    then
	crotate=1
    else
	if [ "$rrotate" != '' ]
	then
	    crotate=3
	else
	    if [ "$irotate" != '' ]
	    then
		crotate=2
	    else
		crotate=0
	    fi
	fi
    fi

    if [ $crotate != $rotate ] &&  [ ! -f /tmp/rotate_kde_pid ];
    then
	xrandr -o $(( rotate * 1 ))
	for input in ${xinputs[@]}; do
	    case $rotate in
		0 ) xinput set-prop $input "Coordinate Transformation Matrix" 1 0 0 0 1 0 0 0 1 ; echo "normal";;
		1 ) xinput set-prop $input "Coordinate Transformation Matrix" 0 -1 1 1 0 0 0 0 1; echo "rechts";;
		2 ) xinput set-prop $input "Coordinate Transformation Matrix" -1 0 1 0 -1 1 0 0 1; echo "invert";;
		3 ) xinput set-prop $input "Coordinate Transformation Matrix" 0 1 0 -1 0 1 0 0 1 ; echo "links";;
                
	    esac
	done
    fi

    sleep 1
done
