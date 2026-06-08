#!/bin/bash

while [ $# -gt 0 ]; do
  case $1 in
    -n | --name)
      name=$2
      shift
      ;;
    *)
      echo "Invalid option: $1" >&2
      exit 1
      ;;
  esac
  shift
done

pane_id="$(tmux show -g @${name}_pane_id | awk -F'"' '{print $2}')"
pane_exists="$(tmux has -t $pane_id 2>/dev/null && echo 1)"

if [[ ! -z "$pane_exists"  ]]; then
  tmux kill-pane -t "$pane_id"
fi



