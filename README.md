# entertainment-wave-2021

## Installing

The following steps were executed on a Raspberry Pi 4, with [RaspiOS installed first](https://www.raspberrypi.com/documentation/computers/getting-started.html) and [RetroPie installed over the OS](https://retropie.org.uk/docs/Manual-Installation/).
I will just provide the basic steps for my configuration, although other Linux setups should be able to run it with the correct tweaks.

- Install Qt5 and QtQuick
```
sudo apt-get update;
sudo apt-get install qt5-default;
sudo apt-get install qml-module-qtquick-controls;
```
- Install VCR_OSD_MONO Font
```
sudo cp fonts/VCR_OSD_MONO_1.001.ttf /usr/share/fonts/
```
- Copy script and playlist folder from source directory to build dir
```
cp -r wave/script wave/playlist build-wave-Desktop-Debug/
```
Here you can already run ./wave and see the menu screen.

### Spotify-tui and Spotifyd

Please, follow the instalation steps on the repositories for [Spotify-tui](https://github.com/Rigellute/spotify-tui) and [Spotifyd](https://github.com/Spotifyd/spotifyd).

### Configure the CRT resolution

I used this [Reddit post](https://www.reddit.com/r/RetroPie/comments/q91tlj/pi4_35mm_to_rca_composite_on_a_crt_240p_now/) as reference.

The main RetroPie core configuratios and shadders are from the [Sakitoshi repository](https://github.com/Sakitoshi/retropie-crt-tvout). 
The most important aspect of this configuration is that Overscan is disabled by default on the Raspi configuration file, so each emulation core will crop the screen by itself. Keep that in mind for now.

The [b0xspread repository](https://github.com/b0xspread/rpi4-crt) contains the vmodes_watcher.py, a scrip which waits for the Emulation Cores to load before changing the resolution to 240p. 
This will make sure that only the games will run on 240p, while other applications on the Pi will run on 480i.

### Set Openbox as Default Window Manager

TODO

### Install and Configure XTerm as the main console

TODO


