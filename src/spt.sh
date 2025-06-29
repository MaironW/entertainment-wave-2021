#!/bin/bash

# Path to your antimicrox profile
PROFILE="$HOME/.config/antimicrox/spt_keymap.gamepad.amgp"

# Launch antimicrox in the background with the profile
antimicrox --profile "$PROFILE" --hidden &
ANTIMICROX_PID=$!

# Run spotify-tui
spt

# After spotify-tui exits, kill antimicrox
kill $ANTIMICROX_PID
