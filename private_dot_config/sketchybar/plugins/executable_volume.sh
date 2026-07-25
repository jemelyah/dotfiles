#!/bin/bash
VOLUME="${INFO:-$(osascript -e 'output volume of (get volume settings)')}"

if [ "$VOLUME" -eq 0 ] 2>/dev/null; then
  ICON="󰝟"
elif [ "$VOLUME" -lt 50 ] 2>/dev/null; then
  ICON="󰖀"
else
  ICON="󰕾"
fi

sketchybar --set "$NAME" icon="$ICON" label="${VOLUME}%"
