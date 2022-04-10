#!/bin/bash

# boot options can be: ["wave","emulationstation","startx","cli"]
boot='wave'

case $boot in
	"wave")
		sudo update-alternatives --set x-session-manager /usr/bin/openbox-session
		startx
		;;
	"emulationstation")
		emulationstation --resolution 1440 1080 --screnoffset 560 0
		bash bootselection.sh wave
		bash bootrun.sh
		;;
	"startx")
		sudo update-alternatives --set x-session-manager /usr/bin/startlxde-pi
		killall xinit
		startx
		bash bootselection.sh wave
		bash bootrun.sh
		;;
	"cli")
		killall xinit
		;;
	*)
		;;
esac

