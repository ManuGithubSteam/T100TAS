#!/bin/bash
# powertop tuneables give about 20 min of extra power, execute as root!

echo '0' > '/proc/sys/kernel/nmi_watchdog'
echo '1500' > '/proc/sys/vm/dirty_writeback_centisecs'
echo 'auto' > '/sys/bus/i2c/devices/i2c-10/device/power/control'
echo 'auto' > '/sys/bus/pci/devices/0000:00:00.0/power/control'
echo 'auto' > '/sys/bus/pci/devices/0000:00:1a.0/power/control'
echo 'auto' > '/sys/bus/pci/devices/0000:00:14.0/power/control'
echo 'auto' > '/sys/bus/pci/devices/0000:00:1f.0/power/control'

