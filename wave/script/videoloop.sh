#!/bin/bash
VPATH="/media/pi/Mairon/video"

while true; do
	if ps ax | grep -v grep | grep omxplayer > /dev/null
	then
		sleep 1;
	else
		for entry in $VPATH/*
		do
		#	clear
			echo $entry
			omxplayer -r $entry > /dev/null
		done
	fi
done
