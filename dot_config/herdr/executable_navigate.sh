#!/bin/sh
# Vim-aware pane navigation: forward the key to Vim/fzf, otherwise move Herdr focus.
# Usage: navigate.sh <left|down|up|right> <key>
pane=$HERDR_ACTIVE_PANE_ID
if herdr pane process-info --pane "$pane" | grep -Eqi '"name":"(g?(view|l?n?vim?x?)(diff)?|fzf)"'; then
  exec herdr pane send-keys "$pane" "$2"
fi
exec herdr pane focus --direction "$1" --pane "$pane"
