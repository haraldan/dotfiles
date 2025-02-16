#!/bin/bash

handle_options() {
  while [ $# -gt 0 ]; do
    case $1 in
      -n | --name)
        name=$2
        shift
        ;;
      -c | --command)
        command=$2
        shift
        ;;
      -h | --horizontal)
        split_flag="-h"
        ;;
      -v | --vertical)
        split_flag=""
        ;;
      -l)
        split_size=$2
        shift
        ;;
      *)
        echo "Invalid option: $1" >&2
        exit 1
        ;;
    esac
    shift
  done
}

# default values:
name="temp"
command=""
split_flag=""
split_size="50%"

handle_options "$@"



pane_id="$(tmux show -g @${name}_pane_id | awk -F'"' '{print $2}')"
pane_exists="$(tmux has -t $pane_id 2>/dev/null && echo 1)"

if [[ -z "$pane_exists"  ]]; then
  pane_id=$(tmux split-window -d ${split_flag} -l "${split_size}" -P -F "#{pane_id}")
  tmux set -g @${name}_pane_id "$pane_id"
  tmux send-keys -t $pane_id "$command" ENTER
fi


