#!/usr/bin/env bash

PROCESS_NAME="stalonetray"

# Function to get screen width
get_screen_width() {
  xrandr --current | grep '*' | uniq | awk '{print $1}' | cut -d 'x' -f1
}

# Function to check if window is visible
is_visible() {
  i3-msg -t get_tree | jq -r 'recurse(.nodes[]) | select(.window_properties.class=="stalonetray") | .visible' | grep -q "true"
}

# Function to force refresh stalonetray
refresh_stalonetray() {
  # Send a USR1 signal to stalonetray to force refresh
  pkill -USR1 -x "$PROCESS_NAME"
}

# Check if stalonetray process is running
if pgrep -x "$PROCESS_NAME" >/dev/null; then
  if is_visible; then
    # Hide it
    i3-msg "[class=\"$PROCESS_NAME\"] scratchpad show"
  else
    # Show it and position it
    SCREEN_WIDTH=$(get_screen_width)
    X_POS=$((SCREEN_WIDTH - 37)) # 10px from right edge
    Y_POS=30                     # 30px from top

    # Show and position the window
    i3-msg "[class=\"$PROCESS_NAME\"] scratchpad show, move position $X_POS $Y_POS"

    # Force refresh after showing
    sleep 0.1
    refresh_stalonetray
  fi
else
  # Start the process
  "$PROCESS_NAME" &

  # Wait for window to appear (max 5 seconds)
  for i in {1..50}; do
    if i3-msg -t get_tree | grep -q "\"class\":\"$PROCESS_NAME\""; then
      # Move to scratchpad and hide
      i3-msg "[class=\"$PROCESS_NAME\"] floating enable, move scratchpad"
      break
    fi
    sleep 0.1
  done
fi
