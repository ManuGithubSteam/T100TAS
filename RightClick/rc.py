#!/usr/bin/python3
#Copyright (c) 2016 Manuel Soukup

#Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

#The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#####
import sh
import datetime
import threading 
import time
import subprocess
import sys
import fnmatch

#####

WAIT_TIME=0.35 # seconds
TREMOR_SMOOTHING=30 # pixels, dont go too high!
# please check your number of the touchscreen with xinput list    
touchscreen_devices = ["ATML1000:00", "SIS0817:00"]

######

timer_started=0
press_time=datetime.datetime.now()
xinputStr = ""

#x_press=None
#y_press=None

def find_xinput_dev(devicename):
	result = ""
	try:	
			p = subprocess.Popen(['sudo xinput list | grep ' + devicename], stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True)
			out, err = p.communicate()
			if len(err) == 0:
					results = fnmatch.filter(str(out.decode('utf8')).split(), 'id=*')
					print(results)
					if len(results) >= 1:
							if len(results) > 1:
									print("warn: more than one matches in xinput list for device name " + devicename + ". Using the first match")
							result = results[0][3:]
					else:
							print("warn: no match in xinput list found for device name " + devicename)
			else:
					print("error: calling xinput(" + err + ")")
	except:
		print("error: + " + str(sys.exc_info()))
		
	return result

def timer():
	while 1:
		time.sleep(0.05)
		global timer_started
		global press_time
		global WAIT_TIME
		c = datetime.datetime.now() - press_time
		elapsed=c.total_seconds()
		
		if elapsed>WAIT_TIME and timer_started==1:
			print("did not remove finger - RIGHT CLICK")
			timer_started=-1
			sh.xdotool("click", 3, _iter=True)
		#else:
		#	print("finger removed before time waS UP")
		

def x_listener():
	x_press=None
	y_press=None
	global xinputStr
	#print(xinputStr)
	for line in sh.xinput("test", xinputStr, _iter=True):
		global press_time
		global timer_started
		#global x_press,y_press
		
		#print(line)
		splitlineraw=line.split(" ")
		splitline=""+splitlineraw[0]+" "+splitlineraw[1]
		#print(splitlineraw)
		
		if splitline=="button release":
				timer_started=-1
		
		if splitlineraw[0]=="motion" and timer_started==1:
			print("tremor or dragging")
			current_x=int(splitlineraw[1].split('=', 1)[-1])
			current_y=int(splitlineraw[2].split('=', 1)[-1])
			
			if x_press+TREMOR_SMOOTHING>current_x and x_press-TREMOR_SMOOTHING<current_x and y_press+TREMOR_SMOOTHING>current_y and y_press-TREMOR_SMOOTHING<current_y:
				print("inside box - go ahead")
				#print(x_press)
				#print(y_press)
				
			else:
				print("outside box propably draggin")
				print("deactivate right click")
				timer_started=-1
				#print(x_press)
				#print(y_press)
				
		if splitline=="button press":
			print("button press")
			x_press=int(splitlineraw[5].split('=', 1)[-1])
			y_press=int(splitlineraw[6].split('=', 1)[-1])
			timer_started=1
			press_time=datetime.datetime.now()


xl = threading.Thread(name='x_listener', target=x_listener)
t = threading.Thread(name='timer', target=timer)

for dev in touchscreen_devices:
	if xinputStr == "":
		xinputStr = find_xinput_dev(dev)
		#print(xinputStr)

xl.start()
t.start()

print("")
print("right click script started")
print("KILL with: CTRL+C")
print("")
