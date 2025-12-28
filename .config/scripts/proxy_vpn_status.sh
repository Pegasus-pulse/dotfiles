#!/usr/bin/env bash

SERVICE_NAME="v2raya.service"
STATE_FILE="/tmp/v2ray_service_state.txt"
SEARXNG_DIR="/opt/Dockerstuff"

if [[ -f "$STATE_FILE" ]]; then
  PREVIOUS_STATE=$(<"$STATE_FILE")
else
  PREVIOUS_STATE="unknown"
  # Skip notifications on the first run
  FIRST_RUN=true
fi

if systemctl is-active --quiet "$SERVICE_NAME"; then
  CURRENT_STATE="running"
  echo "" # Service is running
else
  CURRENT_STATE="stopped"
  echo "" # Service is not running
fi

run_docker_commands() {
  if [ ! -d "$SEARXNG_DIR" ]; then
    notify-send -a "v2raystatus" -u low -r 9993 "Error" "Directory $SEARXNG_DIR does not exist" -t 5000
    return 1
  fi

  cd "$SEARXNG_DIR" || {
    notify-send -a "v2raystatus" -u low -r 9993 "Error" "Cannot change to $SEARXNG_DIR directory" -t 5000
    return 1
  }

  if [ ! -f "docker-compose.yml" ] && [ ! -f "compose.yml" ]; then
    notify-send -a "v2raystatus" -u low -r 9993 "Error" "No docker-compose.yml or compose.yml file found in $SEARXNG_DIR" -t 5000
    return 1
  fi

  DOWN_OUTPUT=$(docker compose down 2>&1)
  DOWN_EXIT_CODE=$?

  UP_OUTPUT=$(docker compose up -d 2>&1)
  UP_EXIT_CODE=$?

  #NOTIFICATION_MSG="Docker commands executed:\n\n"
  #NOTIFICATION_MSG+="docker compose down:\n$DOWN_OUTPUT\n\n"
  NOTIFICATION_MSG="docker compose up -d:\n$UP_OUTPUT"

  notify-send -a "v2raystatus" -u normal -r 9993 "Docker Commands" "$NOTIFICATION_MSG" -t 5000

  # Return the exit codes (0 if both succeeded)
  return $((DOWN_EXIT_CODE + UP_EXIT_CODE))
}

if [ "$FIRST_RUN" != true ] && [ "$CURRENT_STATE" != "$PREVIOUS_STATE" ]; then
  if [ "$CURRENT_STATE" == "running" ]; then
    notify-send -a "v2raystatus" -u low -r 9992 -i "shield-up" "V2ray connected" -t 2500
    #sleep 2m
    #run_docker_commands
  else
    notify-send -a "v2raystatus" -u low -r 9992 -i "shield-down" "V2ray disconnected" -t 2500
    #sleep 3s
    #run_docker_commands
  fi
fi

echo "$CURRENT_STATE" >"$STATE_FILE"
