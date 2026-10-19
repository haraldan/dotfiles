#!/bin/sh
# Vim-aware pane navigation with tmux-style wraparound.
# Usage: navigate.sh <left|down|up|right> [key]
# With a key, forward it to Vim/fzf when they are in the foreground; otherwise unzoom and move Herdr focus.
pane=${HERDR_ACTIVE_PANE_ID:-$HERDR_PANE_ID}
if [ -n "$2" ] && herdr pane process-info --pane "$pane" | grep -Eqi '"name":"(g?(view|l?n?vim?x?)(diff)?|fzf)"'; then
  exec herdr pane send-keys "$pane" "$2"
fi
herdr pane zoom --pane "$pane" --off >/dev/null
case $(herdr pane focus --direction "$1" --pane "$pane") in
  *'"no_neighbor"'*) ;;
  *) exit 0 ;;
esac
case $1 in
  left) opposite=right ;;
  right) opposite=left ;;
  up) opposite=down ;;
  down) opposite=up ;;
esac
while :; do
  out=$(herdr pane focus --direction "$opposite" --pane "$pane")
  case $out in
    *'"changed":true'*) ;;
    *) break ;;
  esac
  pane=$(printf '%s' "$out" | sed -n 's/.*"focused_pane_id":"\([^"]*\)".*/\1/p')
done