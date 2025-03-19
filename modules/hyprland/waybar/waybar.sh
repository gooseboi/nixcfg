#!/bin/sh

# Terminate already running bar instances
ps aux | grep -P 'waybar$' | grep -v grep | awk '{print $2}' | xargs -n1 kill

# Wait until the processes have been shut down
while pgrep -x waybar >/dev/null; do sleep 1; done

# Launch main
waybar
