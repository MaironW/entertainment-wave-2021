#!/usr/bin/bash
firefox -new-window -kiosk https://www.my"$1"tv.com/ & xdotool sleep 5 search "Mozilla Firefox" windowactivate --sync sleep 7 key --clearmodifiers F F F P space
