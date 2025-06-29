#!/bin/bash

echo "Starting installer..."

# Copy boot script
echo "Copying boot script to home directory..."
cp ../utils/bootrun.sh ~/
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

# Set up Openbox autostart
OPENBOX_AUTOSTART="$HOME/.config/openbox/autostart"
mkdir -p "$(dirname "$OPENBOX_AUTOSTART")"
cat << 'EOF' > "$OPENBOX_AUTOSTART"
# Set screen resolution for CRT TV
./home/pi/set_xrandr

# Run wave in kiosk mode
cd ~/entertainment-wave-2021/wave2/
./wave
EOF
chmod +x ~/set_xrandr

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

# Add keybind to rc.xml
RC_XML="$HOME/.config/openbox/rc.xml"
if [ -f "$RC_XML" ]; then
  echo "Modifying $RC_XML to add Ctrl+Alt+T shortcut..."
  sed -i '/<keyboard>/a\
<!-- Launch Terminal -->\
<keybind key="C-A-t">\
  <action name="Execute">\
    <command>xterm -fullscreen</command>\
  </action>\
</keybind>' "$RC_XML"
else
  echo "$RC_XML not found. Please create or populate it with Openbox default content before rerunning."
fi

echo "Installation complete. Please reboot the system to apply all changes."
