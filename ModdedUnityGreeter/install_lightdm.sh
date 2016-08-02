#!/bin/bash

sudo dpkg -i unity-greeter*.deb

sudo cp com.canonical.unity-greeter.gschema.xml /usr/share/glib-2.0/schemas/
sudo cp org.*.xml /usr/share/glib-2.0/schemas/

sudo glib-compile-schemas /usr/share/glib-2.0/schemas/

