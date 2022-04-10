#!/bin/bash
# script to run at login into pi user
# it starts the connection with Wii U Pro Controller
# and than let the user select to run emulationstation or x

printf "\n"
printf " ########################\n"
printf " #                      #\n"
printf " # WELCOME TO MAIRON PI #\n"
printf " #                      #\n"
printf " ########################\n"

printf "\n Attempting to connect to Wii U Pro Controller\n"
printf " Please press the pair button\n"

mac="8C:CD:E8:B5:C7:02" # Wii U Pro Controller mac address

function connected {
	bluetoothctl info $mac | grep 'Connected: yes'
}

function paired {
	bluetoothctl info $mac | grep 'Paired: yes'
}

function trusted {
	bluetoothctl info $mac | grep 'Trusted: yes'
}

bluetoothctl -- power on
bluetoothctl -- agent on

until [[ $(connected) ]]
do
	if ! [[ $(paired) ]]
	then
		bluetoothctl -- pair $mac
	fi

	if ! [[ $(trusted) ]]
	then
		bluetoothctl -- trust $mac
	fi

	bluetoothctl -- connect $mac > /dev/null
	sleep 2
done
printf " -> Controller succesfull connected.\n"

#bluetoothctl -- disconnect $mac

printf "\n Press Start to run Emulationstation or Select to run Raspberry Pi OS\n"

btn=$(jstest --event /dev/input/js0 | grep -m 1 "type 1, time .*, number .*, value 1" | awk -F"[, ]" '{print $9}' )

if [ "$btn" -eq 9 ]
then
	printf "\n -> Starting Emulationstation\n"
	emulationstation --resolution 1440 1080 --screenoffset 560 0
elif [ "$btn" -eq 8 ]
then
	printf "\n -> Starting Raspberry Pi OS\n"
	startx
fi

exit 0




