#!/usr/bin/env sh

# Terminate already running bar instances
polybar-msg cmd quit

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar > /dev/null; do sleep 1; done

# Get the list of connected monitors
connected_monitors=$(xrandr --query | grep " connected" | cut -d" " -f1)

# Check if there is only one monitor connected
if [ "$(echo "$connected_monitors" | wc -l)" -eq 1 ]; then
    # Get the name of the only connected monitor
    single_monitor=$(echo "$connected_monitors" | head -n 1)
    MONITOR=$single_monitor polybar -r pulse1 2>&1 | tee -a /tmp/polybar.log &
fi

# If both DP-1 and HDMI-2 are connected
if echo "$connected_monitors" | grep -q "DP-1" && echo "$connected_monitors" | grep -q "HDMI-2"; then
    MONITOR=HDMI-2 polybar -r pulse1 2>&1 | tee -a /tmp/polybar.log &
    MONITOR=DP-1 polybar -r pulse2 2>&1 | tee -a /tmp/polybar2.log &
fi

