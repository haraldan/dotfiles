#!/bin/sh
# Vim-aware pane resize.
# Usage: resize.sh <left|down|up|right> <key>
# Forward the key to Vim when it is in the foreground; otherwise resize the Herdr pane.
pane=${HERDR_ACTIVE_PANE_ID:-$HERDR_PANE_ID}
if herdr pane process-info --pane "$pane" | grep -Eqi '"name":"(g?(view|l?n?vim?x?)(diff)?)"'; then
  exec herdr pane send-keys "$pane" "$2"
fi
exec herdr pane resize --pane "$pane" --direction "$1"
