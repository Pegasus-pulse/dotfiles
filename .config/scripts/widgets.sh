#!/usr/bin/env bash

case "$1" in
  calendar)
    POPUP="calendar_popup"
    ;;
  tray)
    POPUP="systray"
    ;;
  *)
    echo "Usage: $0 {calendar|tray}" >&2
    exit 1
    ;;
esac

if eww active-windows | grep -q "^${POPUP}:"; then
  eww close "$POPUP"
else
  eww open-many "$POPUP"
fi
