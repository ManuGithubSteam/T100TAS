#!/bin/bash
#Script by LinuxMachine 2016 and Lionel Dor

if [ -f ~/.toggle-SpeakerHP ]
  then
    rm ~/.toggle-SpeakerHP
    
amixer set Speaker on
amixer set Speaker Channel on
amixer set Headphone off
amixer set HP Channel off
amixer set HP L off
amixer set HP R off

else

echo "Speaker On / HP off" > ~/.toggle-SpeakerHP

amixer set Speaker off
amixer set Speaker Channel off
amixer set Headphone on
amixer set HP Channel on
amixer set HP L on
amixer set HP R on

fi
