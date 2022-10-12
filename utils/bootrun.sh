#!/bin/bash

# Mount USB Stick
sudo mount /dev/sda1 /media/usb_device

# Run Wave (Openbox)
sudo update-alternatives --set x-session-manager /usr/bin/openbox-session;
startx -- -nocursor;

# exit_to option can be: ["emulationstation","pios","cli"]
exit_to='emulationstation'

case $exit_to in
	"emulationstation")
		#emulationstation --resolution 1440 1080 --screenoffset 560 0;
		python3 ~/vmodes_watcher.py &
		emulationstation --resolution 640 440 --screenoffset 40 -20
		;;
	"pios")
		sudo update-alternatives --set x-session-manager /usr/bin/startlxde-pi;
		startx;
		;;
	"cli")
		openbox --exit;
		;;
	*)
		;;
esac

bash bootrun.sh;
