#!/bin/bash

dap_pane_id="$(tmux show -g @dap_pane_id | awk -F'"' '{print $2}')"
dap_pane_exists="$(tmux has -t $dap_pane_id 2>/dev/null && echo 1)"

if [[ ! -z "$dap_pane_exists"  ]]; then
  tmux kill-pane -t "$dap_pane_id"
fi



