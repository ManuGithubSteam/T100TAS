#!/bin/bash

sleep 4


pstree | grep onboard 

echo $? > /tmp/onboard
#echo "test" >> /tmp/onboard

#xdotool getmouselocation >> /tmp/onboard
pstree | grep onboard
#echo $?

if [ $? == 0 ]; then
# onboard is running

 
#echo "ficken" >> /tmp/onboard
#xdotool getmouselocation >> /tmp/onboard
if [ -d /dev/input/by-id ]; then

 # docked deactivate onboard
#echo "ficken 2" >> /tmp/onboard
   #sleep 3


   #landscape mode
#xdotool mousemove --sync $XVAR 8
#sleep 0.5
#xdotool click 1
#sleep 0.5
#xdotool mousemove --sync $XVAR 25
#sleep 0.5
#xdotool click 1

xdotool key ctrl+h

else
echo " not dockeddocked"
# onboard running and not docked do nothing
#echo "ficken 3" >> /tmp/onboard
#xdotool getmouselocation >> /tmp/onboard
fi

else

echo "onboard not running"
#echo "ficken 4" >> /tmp/onboard
#xdotool getmouselocation >> /tmp/onboard
if [ ! -d /dev/input/by-id ]; then

 #  not docked activate onboard

   #sleep 3
#echo "ficken 5" >> /tmp/onboard

   #landscape mode
#xdotool mousemove --sync $XVAR 8
#sleep 0.5
#xdotool click 1
#sleep 0.5
#xdotool mousemove --sync $XVAR 25
#sleep 0.5
#xdotool click 1

xdotool key ctrl+h

else
echo " dockeddocked"
# onboard not running and docked do nothing
#echo "ficken 6" >> /tmp/onboard
#xdotool getmouselocation >> /tmp/onboard
fi

fi
