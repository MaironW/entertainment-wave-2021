#!/bin/bash

# boot options can be: ["wave","emulationstation","startx","cli"]
boot='cli'

case $boot in
	"wave")
		sudo update-alternatives --set x-session-manager /usr/bin/openbox-session
		startx
		bash bootrun.sh
		;;
	"emulationstation")
		emulationstation --resolution 1440 1080 --screnoffset 560 0
		bash bootselection.sh wave
		bash bootrun.sh
		;;
	"startx")
		sudo update-alternatives --set x-session-manager /usr/bin/startlxde-pi
		bash bootselection.sh wave
		bash bootrun.sh
		startx
		;;
	"cli")
		;;
	*)
		;;
esac

