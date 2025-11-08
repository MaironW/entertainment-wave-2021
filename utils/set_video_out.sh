#!/bin/bash

active_output=$(xrandr | grep " connected" | awk '{print $1}')

if [ "$active_output" = "HDMI-1" ]; then
    xrandr --output HDMI-1 --auto --output Composite-1 --off
elif [ "$active_output" = "Composite-1" ]; then
    xrandr --newmode CRT 25.00  680 696 760 840  480 483 493 500 -hsync +vsync
    xrandr --addmode Composite-1 CRT
    xrandr --output Composite-1 --fb 680x480 --panning 680x480 --mode CRT --transform 1,0,-30,0,1,-10,0,0,1
fi