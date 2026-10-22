#!/bin/sh

source "$CONFIG_DIR/colors.sh"

case "$NAME" in
  *[13579]) SPACE_COLOR="$COLOR_IRIS" ;;
  *) SPACE_COLOR="$COLOR_ROSE" ;;
esac

if [ "$SELECTED" = true ]; then
  sketchybar --set "$NAME" \
    background.drawing=on \
    background.color="$SPACE_COLOR" \
    label.color="$COLOR_SPACE_SEL_FG" \
    icon.color="$COLOR_SPACE_SEL_FG"
else
  sketchybar --set "$NAME" \
    background.drawing=on \
    background.color="$COLOR_SPACE_UNSEL_BG" \
    label.color="$SPACE_COLOR" \
    icon.color="$SPACE_COLOR"
fi
