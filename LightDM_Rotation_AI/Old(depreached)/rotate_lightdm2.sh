#!/bin/bash

# Based on an original by Maxwell Pray (synthead), from
# https://bbs.archlinux.org/viewtopic.php?id=107167

# edited for KDE rotation by Stefan

# This version supports angles (sort of)

#The MIT License (MIT)
#Copyright (c) 2016 Stefan Möbius and Manuel Soukup

#Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

#The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# DO NOT EXECUTE AS ROOT!!!!

pointers="$(xinput list)"
xinputs=(2 4 10 13 )
PID=$$

echo $PID > /tmp/rotate_lightdm_pid
lrotate=-1
rotate=0
  
while true
do
    xrandrout="$(xrandr)"
    x=$(cat /sys/bus/iio/devices/iio\:device1/in_accel_x_raw)
    y=$(cat /sys/bus/iio/devices/iio\:device1/in_accel_y_raw)
    z=$(cat /sys/bus/iio/devices/iio\:device1/in_accel_z_raw)
    x2=$((x*x))
    y2=$((y*y))
    z2=$((z*z)) 
    x2h=$((x2*6/8)) # speddy change if increase 6 
    y2h=$((y2*6/8)) # speddy change if increase 6 
    z2h=$((z2*6/8)) # speddy change if increase 6 
     
    x3=$((x/1000))
    y3=$((y/1000))
    z3=$((z/1000))   
    dist=$((x3*x3+y3*y3+z3*z3))
    #echo $dist
    
    if [ $dist -gt 200 ]
    then
        if [ $dist -lt 320 ]
        then    
            
            rotate=0

            if [ $x2h -gt $y2 ]
            then
                if [ $x2h -gt $z2 ]
                then 
                if [ $x -gt 0 ]
                    then         
                        rotate=1 
                    else
                        rotate=3
                    fi
                fi
            fi
            

            if [ $y2h -gt $x2 ]
            then
                if [ $y2h -gt $z2 ]
                then 
                if [ $y -gt 0 ]
                    then         
                        rotate=0 
                    else
                        rotate=2
                    fi
                fi
            fi    
            

            if [ $z2h -gt $x2 ]
            then
                if [ $z2h -gt $y2 ]
                then        

                    
                        if [ $y2h -gt $x2 ]
                        then
                            if [ $y -gt 0 ]
                            then        
                                rotate=0 
                            else
                                rotate=2
                            fi
                        fi
                        if [ $x2h -gt $y2 ] 
                        then                      
                            if [ $x -gt 0 ]
                            then        
                                rotate=1 
                            else
                                rotate=3
                            fi                
                        fi
                    

                fi
            fi    
            
        fi
    fi
    
    if [ $rotate -ne $lrotate ]&&  [ ! -f /tmp/rotate_kde_pid ]
    then
	xrandr -o $(( rotate * 1 ))
	for input in ${xinputs[@]}; do
	    case $rotate in
		0 ) xinput set-prop $input "Coordinate Transformation Matrix" 1 0 0 0 1 0 0 0 1;;
		1 ) xinput set-prop $input "Coordinate Transformation Matrix" 0 -1 1 1 0 0 0 0 1;;
		
		2 ) xinput set-prop $input "Coordinate Transformation Matrix" -1 0 1 0 -1 1 0 0 1;;
		3 ) xinput set-prop $input "Coordinate Transformation Matrix" 0 1 0 -1 0 1 0 0 1;;
# 		0 ) ./rotate_kde.py --rotation 1 && xinput set-prop $input "Coordinate Transformation Matrix" 1 0 0 0 1 0 0 0 1;;
# 		
# 		1 ) ./rotate_kde.py --rotation 2 && xinput set-prop $input "Coordinate Transformation Matrix" 0 -1 1 1 0 0 0 0 1;;
#                 2 ) ./rotate_kde.py --rotation 4 &&xinput set-prop $input "Coordinate Transformation Matrix" -1 0 1 0 -1 1 0 0 1;;
#                 3 ) ./rotate_kde.py --rotation 8 && xinput set-prop $input "Coordinate Transformation Matrix" 0 1 0 -1 0 1 0 0 1;;
                
	    esac
	done
	lrotate=$rotate 
    fi

    sleep 0.1
done
