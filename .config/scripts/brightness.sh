#!/usr/bin/env bash

# Define your serial numbers here
SERIAL_MAIN="CN453802XF"
SERIAL_SECOND="K4122"

TARGET_SERIAL="" # Empty variable

# Check if the first argument looks like a serial number.
if [[ "$1" =~ [A-Za-z] ]]; then
  TARGET_SERIAL="$1"
  shift
fi

if [ -z "$TARGET_SERIAL" ]; then
  FOCUSED_OUTPUT=$(i3-msg -t get_outputs | jq -r '.[] | select(.focused) | .name')

  case "$FOCUSED_OUTPUT" in
  DP-1)
    TARGET_SERIAL="$SERIAL_MAIN"
    ;;
  DP-2)
    TARGET_SERIAL="$SERIAL_SECOND"
    ;;
  *)
    TARGET_SERIAL="$SERIAL_MAIN"
    ;;
  esac
fi

ddcutil --sn "$TARGET_SERIAL" setvcp 10 "$@"

# Use awk to extract the number after "current value = "
brightness=$(ddcutil --sn "$TARGET_SERIAL" getvcp 10 | awk -F',' '{split($1, a, "= "); print a[2]+0}')

if [[ -n "$brightness" ]]; then
  notify-send -a "task" -u low -r 9992 -i "brightness" "Brightness ${brightness}%" -t 2000
fi
