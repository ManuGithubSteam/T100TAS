#!/bin/bash

echo "ai collect collection" 

echo "sleep 10 sec"

killall rotate2.sh
killall rotate2.sh
killall rotate2.sh


sleep 10

m=1

while [ $m -le 100 ]
do
echo "training running $m"
    x=$(cat /sys/bus/iio/devices/iio\:device1/in_accel_x_raw)
    y=$(cat /sys/bus/iio/devices/iio\:device1/in_accel_y_raw)
    z=$(cat /sys/bus/iio/devices/iio\:device1/in_accel_z_raw)

    # 1 = normal landscape
    # 2 = 90 degree right
    # 4 = inverted
    # 8 = left 90/270 degree
    #
    # edit the last number(now 4)!
    
echo "$x $y $z 1 4" >> traning_1-8

m=$(( $m + 1 ))

done

echo "training finished"
echo ""