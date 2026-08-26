#!/bin/sh
LOC=$(curl -s ipinfo.io | grep '"loc":' | awk -F\" '{print $4}')
CITY=$(curl -s ipinfo.io | grep '"city":' | awk -F\" '{print $4}')
ICON="\udb81\udd90"

#text="☀ $(curl -s "https://wttr.in/$LOC?format=1" | awk -F " " '{print $2}')"
text="$ICON $(curl -s "https://wttr.in/$LOC?format=1" | awk -F " " '{print $2}')"
tooltip="$(curl -s "https://wttr.in/$CITY?0QT" |
    sed 's/\\/\\\\/g' |
    sed ':a;N;$!ba;s/\n/\\n/g' |
    sed 's/"/\\"/g')"

if ! grep -q "Unknown location" <<< "$text"; then
    echo "{\"text\": \"$text\", \"tooltip\": \"<tt>$tooltip</tt>\", \"class\": \"weather\"}"
fi

