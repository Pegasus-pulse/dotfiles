#!/usr/bin/env bash

SERVICE_NAME="v2raya.service"
STATE_FILE="/tmp/v2ray_service_state.txt"

if [[ -f "$STATE_FILE" ]]; then
    PREVIOUS_STATE=$(<"$STATE_FILE")
else
    PREVIOUS_STATE="unknown"
    # Skip notifications on the first run
    FIRST_RUN=true
fi

if systemctl is-active --quiet "$SERVICE_NAME"; then
    CURRENT_STATE="running"
    echo ""  # Service is running
else
    CURRENT_STATE="stopped"
    echo ""  # Service is not running
fi

if [ "$FIRST_RUN" != true ] && [ "$CURRENT_STATE" != "$PREVIOUS_STATE" ]; then
    if [ "$CURRENT_STATE" == "running" ]; then
        dunstify -a "v2raystatus" -u low -r 9992 -i "shield-up" "V2ray connected" -t 2500
    else
        dunstify -a "v2raystatus" -u low -r 9992 -i "shield-down" "V2ray disconnected" -t 2500
    fi
fi

echo "$CURRENT_STATE" > "$STATE_FILE"
