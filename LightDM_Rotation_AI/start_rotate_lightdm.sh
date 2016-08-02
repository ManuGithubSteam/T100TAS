#!/bin/sh

#sleep 1

/home/manuel/start_virtk_lightdm.sh &

# use your username here
#sudo su manuel -s/home/manuel/rotate_lightdm_kde_ai.py &

su -c "DISPLAY=:0 XAUTHORITY=/var/run/lightdm/root/$DISPLAY /home/manuel/rotate_lightdm_kde_ai.py" "manuel" &