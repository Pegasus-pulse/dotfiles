#!/usr/bin/env bash

send_notification_up() {
	volume=$(pamixer --get-volume)
	dunstify -a "changevolume" -u low -r 9993 -h int:value:"$volume" -i "volume-up" "${volume}%" -t 2000
}

send_notification_down() {
	volume=$(pamixer --get-volume)
	dunstify -a "changevolume" -u low -r 9993 -h int:value:"$volume" -i "volume-down" "${volume}%" -t 2000
}

case $1 in
up)
	# Set the volume on (if it was muted)
	pamixer -u
	pamixer -i 5 --allow-boost
	send_notification_up "$1"
	;;
down)
	pamixer -u
	pamixer -d 5 --allow-boost
	send_notification_down "$1"
	;;
mute)
	pamixer -t
	if eval "$(pamixer --get-mute)"; then
		dunstify -a "changevolume" -t 2000 -r 9993 -u low -i "volume-mute" "Muted"
	else
		send_notification_up
	fi
	;;
esac
