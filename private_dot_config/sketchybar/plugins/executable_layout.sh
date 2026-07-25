#!/bin/bash
LAYOUT="$(aerospace list-windows --focused --format '%{window-layout}' 2>/dev/null)"

case "$LAYOUT" in
  v_tiles|h_tiles) ICON="⊞" ;;
  v_accordion|h_accordion) ICON="⊟" ;;
  floating) ICON="⊡" ;;
  *) ICON="" ;;
esac

sketchybar --set "$NAME" label="$ICON"
