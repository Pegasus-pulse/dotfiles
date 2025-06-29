#!/usr/bin/env bash

SERVICE_NAME="v2raya.service"

if systemctl is-active --quiet "$SERVICE_NAME"; then
    sudo -A systemctl stop "$SERVICE_NAME"
else
    sudo -A systemctl start "$SERVICE_NAME"
fi

