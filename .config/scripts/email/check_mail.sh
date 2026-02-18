#!/usr/bin/env bash

BASE="$HOME/.config/scripts/email"
STATE="$BASE/gmail_state"
STATE_ICON="/tmp/mailicon.txt"

ACCOUNTS="$BASE/gmail_accounts"
#add your email accounts to a file(gmail_accounts) in the same directory as this script
#LABEL:EMAIL:APP_PASSWORD
#Ex:-
# mymain:helloworld@gmail.com:1111 aaaa 2222 bbbb

TOTAL_UNREAD=0
NEW_ACCOUNTS=""

[ -f "$STATE" ] || touch "$STATE"

while IFS=: read -r LABEL USER PASS; do
    COUNT=$(curl -su "$USER:$PASS" --silent https://mail.google.com/mail/feed/atom | grep -oPm1 '(?<=<fullcount>)[0-9]+')

    [ -z "$COUNT" ] && COUNT=0
    TOTAL_UNREAD=$((TOTAL_UNREAD + COUNT))

    PREV=$(grep "^$USER " "$STATE" | awk '{print $2}')
    PREV=${PREV:-0}

    if [ "$COUNT" -gt "$PREV" ]; then
        DIFF=$((COUNT - PREV))
        NEW_ACCOUNTS="$NEW_ACCOUNTS\n$LABEL ($DIFF)"
    fi

    grep -v "^$USER " "$STATE" >"$STATE.tmp"
    echo "$USER $COUNT" >>"$STATE.tmp"
    mv "$STATE.tmp" "$STATE"

done < "$ACCOUNTS"

if [ -n "$NEW_ACCOUNTS" ]; then
    notify-send -a "mail" -u normal -r 9996 "New Mail" "$(printf "$NEW_ACCOUNTS")"
fi

# Polybar output
if [ "$TOTAL_UNREAD" -gt 0 ]; then
    MAIL_STATUS="" # Got New Mail
else
    MAIL_STATUS="" # No New Mail
fi

#echo "$MAIL_STATUS" > "$STATE_ICON"
echo "$MAIL_STATUS"
