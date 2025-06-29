#!/bin/bash

echo "Starting installer..."

# Copy boot script
echo "Copying boot script to home directory..."
cp utils/bootrun.sh ~/
chmod +x ~/bootrun.sh

# Update ~/.profile to run boot script
PROFILE="$HOME/.profile"
BOOT_COMMAND='
# startup routine
if test -t 0 -a -t 1
then
  bash bootrun.sh
fi
'
if ! grep -q "bash bootrun.sh" "$PROFILE"; then
  echo "Updating $PROFILE to run boot script on login..."
  echo "$BOOT_COMMAND" >> "$PROFILE"
else
  echo "$PROFILE already contains boot script command."
fi

# Enable autologin
echo "Enabling autologin..."
sudo raspi-config nonint do_boot_behaviour B2

# Copy xrandr configuration to home directory
cp /utils/set_xrandr_crt ~/set_xrandr
chmod +x ~/set_xrandr

# Set up Openbox autostart
OPENBOX_AUTOSTART="$HOME/.config/openbox/autostart"
mkdir -p "$(dirname "$OPENBOX_AUTOSTART")"
cat << 'EOF' > "$OPENBOX_AUTOSTART"
# Set screen resolution for CRT TV
./home/pi/set_xrandr

# Run wave in kiosk mode
cd ~/entertainment-wave-2021/src/
./wave
EOF

# Install XTerm
echo "Installing xterm..."
sudo apt-get update
sudo apt-get install -y xterm

# Configure XTerm appearance
echo "Configuring xterm appearance..."
XRES="$HOME/.Xresources"
cat << EOF >> "$XRES"
xterm*faceName: 'Monospace'
xterm*faceSize: 11
xterm*internalBorder: 58
EOF

# Copy rc.xml if missing
RC_XML="$HOME/.config/openbox/rc.xml"
if [ ! -f "$RC_XML" ]; then
  echo "rc.xml not found in user directory. Copying default from /etc/xdg/openbox/rc.xml..."
  mkdir -p "$(dirname "$RC_XML")"
  cp /etc/xdg/openbox/rc.xml "$RC_XML"
fi

# Add keybind to rc.xml
if ! grep -q 'key="C-A-t"' "$RC_XML"; then
  echo "Modifying $RC_XML to add Ctrl+Alt+T shortcut..."
  sed -i '/<keyboard>/a\
<!-- Launch Terminal -->\
<keybind key="C-A-t">\
  <action name="Execute">\
    <command>xterm -fullscreen</command>\
  </action>\
</keybind>' "$RC_XML"
else
  echo "Ctrl+Alt+T shortcut already exists in rc.xml."
fi

# Set up static mount of /dev/sda1 to /media/usb_drive
echo "Setting up static USB mount for /dev/sda1..."

sudo mkdir -p /media/usb_drive
sudo mount /dev/sda1 /media/usb_drive
systemctl daemon-reload

# Copy Picade-M theme to EmulationStation
echo "Installing Picade-M theme into EmulationStation..."

if [ -d "utils/to_emulationstation/picade-m" ]; then
    sudo mkdir -p /etc/emulationstation/themes
    sudo cp -r utils/to_emulationstation/picade-m /etc/emulationstation/themes/
    echo "Picade-M theme installed."
else
    echo "Error: picade-m theme folder not found in utils/to_emulationstation/"
fi

# Make
echo "Building project with make..."

if [ -f "./src/Makefile" ]; then
    make -C ./src
else
    echo "Error: Makefile not found in ./src"
    exit 1
fi

echo "Installation complete. Please reboot to apply all changes."
