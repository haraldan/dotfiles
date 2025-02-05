#!/bin/bash

ipython_pane_id="$(tmux show -g @ipython_pane_id | awk -F'"' '{print $2}')"
ipython_pane_exists="$(tmux has -t $ipython_pane_id 2>/dev/null && echo 1)"

if [[ ! -z "$ipython_pane_exists"  ]]; then
  echo $ipython_pane_id
fi


