#!/usr/bin/env bash
killall waybar
waybar -c ~/.config/waybar/config-custom -s ~/.config/waybar/style-custom.css &

