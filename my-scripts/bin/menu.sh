#!/bin/sh

# dmenu -i -nb $BACK_NORMAL -nf $FORE_NORMAL -sb $BACK_SEL -sf $FORE_SEL -fn "$FONT"
# dmenu -i -fn "xos4 Terminus:size=12:antialias=true:hinting=true"
# rofi -matching fuzzy -scroll-method 1 -dmenu -i "${*:+-p}" "${*:-}"
rofi -scroll-method 1 -dmenu -i "${*:+-p}" "${*:-}"
