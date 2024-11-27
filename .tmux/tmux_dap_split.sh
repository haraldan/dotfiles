#!/bin/bash

command=""
for arg in "$@"; do
  command="$command $arg"
done

dap_pane_id="$(tmux show -g @dap_pane_id | awk -F'"' '{print $2}')"
dap_pane_exists="$(tmux has -t $dap_pane_id 2>/dev/null && echo 1)"

if [[ -z "$dap_pane_exists"  ]]; then
  dap_pane_id=$(tmux split-window -d -l "20%" -P -F "#{pane_id}")
  tmux set -g @dap_pane_id "$dap_pane_id"
  tmux send-keys -t $dap_pane_id "export PROMPT_COMMAND= ; set +o history" ENTER
fi

tmux send-keys -t $dap_pane_id  "$command" ENTER

