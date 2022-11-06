# entertainment-wave-2021

## Base Installation

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

## Spotify-tui and Spotifyd

Please, follow the installation steps on the repositories for [Spotify-tui](https://github.com/Rigellute/spotify-tui) and [Spotifyd](https://github.com/Spotifyd/spotifyd).

## Configure the CRT resolution

I used this [Reddit post](https://www.reddit.com/r/RetroPie/comments/q91tlj/pi4_35mm_to_rca_composite_on_a_crt_240p_now/) as reference.

The main RetroPie core configurations and shaders are from the [Sakitoshi repository](https://github.com/Sakitoshi/retropie-crt-tvout). 
The most important aspect of this configuration is that Overscan is disabled by default on the Raspi configuration file, so each emulation core will crop the screen by itself. Keep that in mind for now.

The [b0xspread repository](https://github.com/b0xspread/rpi4-crt) contains the vmodes_watcher.py, a script which waits for the Emulation Cores to load before changing the resolution to 240p. 
This will make sure that only the games will run on 240p, while other applications on the Pi will run on 480i.

## Configure boot

I prefer to use the boot script on my home directory, but that is optional.

```
cp utils/bootrun.sh ~/
```
Then you must need to edit the `~/.profile` file so the boot script will run as soon as the Pi is logged in. Add the following lines to the end of the file:
```
# startup routine

if test -t 0 -a -t 1
then
  bash bootrun.sh
fi
```
You should also set the Pi to auto login.

## Configure Openbox to launch Wave by default

If you are using RaspiOS, the window manager Openbox should be already installed on your machine.

Add the following to the file `~/.config/openbox/autostart`:

```
# Set screen resolution for CRT TV
./home/pi/set_xrandr

# Run wave in kiosk mode
cd entertainment-wave-2021/build-wave-Desktop-Debug/
./wave
```

## Install and Configure XTerm as the main console

You may already have noticed that using the default console for the Raspi is becoming difficult because of Overscan.

Because Spotify-tui relies on the terminal, it was better to use a standalone terminal, configured according to my screen.

```
sudo apt-get install xterm
```

And then add to the file `~/.Xresources`:
```
xterm*faceName: 'Monospace'
xterm*faceSize: 11
xterm*internalBorder: 58
```
To launch the terminal with Ctrl+Alt+T, edit the file `~/.config/openbox/rc.xml`:
```
<keyboard>
...
<!-- Launch Terminal -->
<keybind key="C-A-t">
  <action name="Execute">
    <command>xterm -fullscreen</command>
  </action>
</keybind>
...
</keyboard>
```

## How to use

### Wave Menu

- Directional keys **up** and **down**: navigate through menu
- **Enter**: select option
- **Backspace**: return to last menu screen

### Cable

### MTV/VHS Collection

### Terminal

### Emulationstation

### Radio
