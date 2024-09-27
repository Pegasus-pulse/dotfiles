#!/usr/bin/env bash

PROCESS_NAME="stalonetray"

# Check if stalonetray process is running
if pgrep -x "$PROCESS_NAME" > /dev/null; then
    pkill -x "$PROCESS_NAME"
else
    "$PROCESS_NAME" &
fi

