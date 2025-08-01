#!/bin/bash

# Start wallpaper daemon
# hyprpaper &
kitty &
waybar -c ~/dotfiles/waybar/config -s ~/dotfiles/waybar/style.css &

# Notification daemon
# dunst &

# Background compositor services
#udiskie &
#blueman-applet &

