#!/usr/bin/env python
# -*- coding: utf-8 -*-
# coding=utf-8

#The MIT License (MIT)
#Copyright (c) 2016 Stefan Möbius and Manuel Soukup

#Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

#The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import dbus
import argparse

parser = argparse.ArgumentParser(description='rotates kde screen.')
parser.add_argument('--rotation', metavar='N', type=int,
                    help=' 1 (normal), 2 (90 degree), 4 (upside down), 8 (270 degree)')

arg = parser.parse_args()

bus = dbus.SessionBus()

the_object = bus.get_object("org.kde.KScreen", "/backend")
the_interface = dbus.Interface(the_object, "org.kde.kscreen.Backend")

reply = the_interface.getConfig()

reply["outputs"][0]["rotation"] = dbus.Double(float(arg.rotation), variant_level=1)

the_interface.setConfig(reply)
the_interface.setConfig(reply) #fix redraw problem