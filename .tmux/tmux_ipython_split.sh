#!/bin/bash

command=""
for arg in "$@"; do
  command="$command $arg"
done

ipython_pane_id="$(tmux show -g @ipython_pane_id | awk -F'"' '{print $2}')"
ipython_pane_exists="$(tmux has -t $ipython_pane_id 2>/dev/null && echo 1)"

if [[ -z "$ipython_pane_exists"  ]]; then
  ipython_pane_id=$(tmux split-window -d -h -l "40%" -P -F "#{pane_id}")
  tmux set -g @ipython_pane_id "$ipython_pane_id"
  tmux send-keys -t $ipython_pane_id "$command" ENTER
fi


