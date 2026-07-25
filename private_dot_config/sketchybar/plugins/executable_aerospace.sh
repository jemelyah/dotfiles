#!/bin/bash
SID="${NAME#space.}"
FOCUSED="${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused)}"

if [ "$SID" = "$FOCUSED" ]; then
  sketchybar --set "$NAME" background.drawing=on background.color=0xff44475a label.color=0xffffffff
else
  sketchybar --set "$NAME" background.drawing=off label.color=0xffaaaaaa
fi
