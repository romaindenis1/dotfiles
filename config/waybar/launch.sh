#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

pkill -q waybar

while pgrep -x waybar >/dev/null; do sleep 1; done

waybar -c "$SCRIPT_DIR/config.jsonc" -s "$SCRIPT_DIR/style.css" &
