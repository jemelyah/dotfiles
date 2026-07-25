#!/bin/bash
SID="${NAME#space.}"
FOCUSED="${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused)}"

if [ "$SID" = "$FOCUSED" ]; then
  sketchybar --set "$NAME" background.drawing=on background.color=0xff89b4fa label.color=0xff1e1e2e
else
  sketchybar --set "$NAME" background.drawing=off label.color=0xff9399b2
fi
