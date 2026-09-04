#!/bin/bash

# Path to your wallpaper directory
WALLPAPER_DIR="$HOME/Imagens/Wallpapers"

# Kill any previous instance of this script so reloads/restarts don't stack up
for pid in $(pgrep -f "$(basename "$0")"); do
    [ "$pid" != "$$" ] && kill "$pid" 2>/dev/null
done

while true; do
    # Pick a random image from the directory
    NEW_WALL=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.png" \) | shuf -n 1)

    # Remember the currently running swaybg (if any) before starting a new one
    OLD_PID=$(pgrep -x swaybg)

    # Start the new swaybg instance
    swaybg -o "*" -i "$NEW_WALL" -m fill &

    # Wait for the new background to load, then kill the old swaybg process
    sleep 1
    [ -n "$OLD_PID" ] && kill "$OLD_PID"

    # Wait 10 minutes (600 seconds) before changing again
    sleep 10
done
