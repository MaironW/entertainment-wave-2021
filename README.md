# entertainment-wave-2021

![Alt text](https://lh3.googleusercontent.com/pw/AL9nZEWEFOHr71fUpD8tdBFyfv1XvFd8ZUj3xU2qjyk3fn6GiPHXSZlprAU8bXTBwnhdnOfnNW3QAUM6Wxc1K0umEi_32tWnk8GqhozvpJoDud08Rhz1bL_s2sxnaNE4GHEl1w02j4SLVV7VEarsbeQKKZHW=w1291-h968-no?authuser=1 "Wave")

This is entertertainment-wave-2021 or as I use to call it, just Wave (because it needed a name anyway). The main goal is to turn your RaspberryPi into a retro media center, able to play videos, music and games.

This is a work-in-progress hobbyist project with no warranties and a lot of improvement possibilities.
I will be happy to receive contributions in the form of Pull Requests or Issues on GitHub.

You can find more info about the project on [Reddit](https://www.reddit.com/r/raspberry_pi/comments/xzuiwh/crt_tvvcr_trinitron_as_a_retro_media_player/) and [YouTube](https://www.youtube.com/watch?v=PuYOWk4aDo4).

## Licensing

Feel free to use this code with no warranties. Although I have no responsibilities about misusing the project, it is a great practice to keep the author's information on the source code (MaironW is fine).

If you think this project is really worth funding, please contact me. It is always great to have resources for more projects.

## Base Installation


- Install dependencies and configure system files
```
bash install.sh
```
- Compile
```
cd src
make
```
Here you can already run `./wave` and see the menu screen.

## Directories

To change the default media directory for VHS and MTV menus, edit the file `src/config.txt`.

## Spotify-tui and Spotifyd

Please, follow the installation steps on the repositories for [Spotify-tui](https://github.com/Rigellute/spotify-tui) and [Spotifyd](https://github.com/Spotifyd/spotifyd).

## Configure the CRT resolution

Up to this point, you might still be operating your Raspi through HDMI. However, you need to change configurations so it outputs video through RCA. This is done manually before the initial setup, as it is optional (some users might want to keep using it on a HDMI screen). The following might work, initially:

```
sudo cp utils/config_default.txt /boot/firmware/config_default.txt
cd /boot/firmware
sudo cp config.txt config_bkp.txt
sudo mv config_default.txt config.txt
```

I used this [Reddit post](https://www.reddit.com/r/RetroPie/comments/q91tlj/pi4_35mm_to_rca_composite_on_a_crt_240p_now/) as reference.

The main RetroPie core configurations and shaders are from the [Sakitoshi repository](https://github.com/Sakitoshi/retropie-crt-tvout).
The most important aspect of this configuration is that Overscan is disabled by default on the Raspi configuration file, so each emulation core will crop the screen by itself. Keep that in mind for now.

The [b0xspread repository](https://github.com/b0xspread/rpi4-crt) contains the vmodes_watcher.py, a script which waits for the Emulation Cores to load before changing the resolution to 240p.
This will make sure that only the games will run on 240p, while other applications on the Pi will run on 480i.

## How to use

### Wave Menu

- Directional keys `up` and `down`: navigate through menu
- `Enter`: select option
- `Backspace`: return to last menu screen

### Cable

On MyRetroTVs you can press H to see the command list. The ones I found more useful are:

- `P`: to toggle Playlist mode. If not in Playlist mode, the same video will play in loop until you chose to change it
- `F`: change the screen focus. Press a few times to get fullscreen
- `Space`: Play/Pause button

I am running the scripts on Firefox, so I can exit it with `Alt+F4` or `Ctrl+Shift+W`.

### MTV/VHS

When playing videos though the MTV/VHS menu, they run on mpv. So the [mpv documentation](https://github.com/mpv-player/mpv) and commands are all valid. The ones I found more useful are:

- `Q`: quit
- `Enter`: go to next video (on Shuffle mode)
- `W` and `E`: adjust Overscan
- `Space`: Play/Pause button

### Emulationstation

On Emulationstation you can operate with your keyboard and also your gamepad controller. You can refer to the RetroPie documentation to understand how to configure your inputs.

When selecting Exit Emulationstation, you will go back to the Wave menu.

### Radio

You can follow the Spotify-tui documentation for how to operate the application. Because it is running on a XTerm instance, pressing `Ctrl+C` will let you exit.
