#!/bin/sh
# Use `iw` to scan for available Wi-Fi networks
INTERFACE=$(iw dev | awk '$1=="Interface"{print $2}')
iw dev "$INTERFACE" scan | grep SSID