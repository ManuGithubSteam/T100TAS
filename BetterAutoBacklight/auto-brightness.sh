#!/bin/bash

## add to sudoers file
## username      ALL = NOPASSWD: ALL

sensitivity=10
min=10
max=255
sensormin=0
sensormax=255
lastsetbacklight=0
delay=5

cpdevnode=`ls /sys/bus/i2c/devices/i2c-CPLM3218\:00/ | grep iio `
cpdevinput="/sys/bus/i2c/devices/i2c-CPLM3218:00/$cpdevnode/in_illuminance_input"
blnode="/sys/class/backlight/intel_backlight/brightness"

echo $max > "$blnode"

lastsetbacklight=$(cat "$blnode")

while [ 1 ]             
do                      
        updated=1
        while [ $updated -gt 0 ]
        do      
                updated=0
                backlight=$(cat "$blnode")
                sensor=$(cat "$cpdevinput")

		echo $sensor                
		#sens=$((sensor*(sensormax/(2*max-2*min))))
		sens=$((sensor/3-20))
		
		if [ $sens -gt $sensormax ]; then
			sens=$sensormax
		fi
		
		if [ $sens -lt $sensormin ]; then
			sens=$sensormin
		fi		
		
		#echo $sens
		
                target=$backlight      
                
                if [ $sens -gt $((backlight+sensitivity)) ]
                then    
                        updated=1
                        target=$sens #$((target+(sensitivity/2)))
                fi      
                
                if [ $sens -lt $((backlight-sensitivity)) ]
                then    
                        updated=1
                        target=$sens #$((target-(sensitivity/2)))
                fi
                
                if [ $target -gt $max ]
                then
                        target=$max
			#updated=0                                   
                fi

                if [ $target -lt $min ]
                then
                        target=$min  
			#updated=0                                      
                fi

                
                if [ $updated -gt 0 ]
                then             
                        
                    if [ $lastsetbacklight -eq $((backlight)) ]
                    then    		
                        echo "Setting bl to $target"                         
                        echo $target > "$blnode"
                        lastsetbacklight=$target
                    fi
                    
                    
                    
                    if [ $backlight -eq $((1)) ]
                    then    
                        lastsetbacklight=$((1))
                    fi
                        
                fi
        done
        sleep $delay
done
