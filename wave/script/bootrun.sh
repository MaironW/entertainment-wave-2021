#!/bin/bash

# Run MyStartup in background
#bash mystartup.sh &

# Run Wave
#sudo update-alternatives --set x-session-manager /usr/bin/openbox-session;
#startx;

# boot options can be: ["wave","emulationstation","pios","cli"]
exit_to='emulationstation'

case $exit_to in
	"emulationstation")
		#emulationstation --resolution 1440 1080 --screenoffset 560 0;
		emulationstation --resolution 640 480;
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
