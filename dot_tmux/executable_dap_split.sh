#!/bin/bash

# Usage: dap_split.sh <command...>   run the command in a reusable split
#        dap_split.sh --close        close the split

if [[ -n "$HERDR_ENV" ]]; then
  state_file="${XDG_RUNTIME_DIR:-/tmp}/herdr_dap_pane_id${HERDR_SOCKET_PATH//\//_}"
  get_pane_id() { cat "$state_file" 2>/dev/null; }
  set_pane_id() { echo "$1" >"$state_file"; }
  pane_exists() { herdr pane get "$1" >/dev/null 2>&1; }
  split_pane() { herdr pane split --current --direction down --ratio 0.8 --cwd "$PWD" --no-focus | sed -E 's/.*"pane_id":"([^"]+)".*/\1/'; }
  send_command() { herdr pane run "$1" "$2" >/dev/null; }
  send_interrupt() { herdr pane send-keys "$1" ctrl+c >/dev/null; }
  close_pane() { herdr pane close "$1" >/dev/null; }
else
  get_pane_id() { tmux show -gv @dap_pane_id 2>/dev/null; }
  set_pane_id() { tmux set -g @dap_pane_id "$1"; }
  pane_exists() { tmux has -t "$1" 2>/dev/null; }
  split_pane() { tmux split-window -d -l "20%" -c "$PWD" -P -F "#{pane_id}"; }
  send_command() { tmux send-keys -t "$1" "$2" ENTER; }
  send_interrupt() { tmux send-keys -t "$1" C-c; }
  close_pane() { tmux kill-pane -t "$1"; }
fi

dap_pane_id="$(get_pane_id)"
dap_pane_exists="$([[ -n "$dap_pane_id" ]] && pane_exists "$dap_pane_id" && echo 1)"

if [[ "$1" == "--close" ]]; then
  if [[ -n "$dap_pane_exists" ]]; then
    close_pane "$dap_pane_id"
  fi
  exit
fi

command=""
for arg in "$@"; do
  command="$command $arg"
done

if [[ -z "$dap_pane_exists" ]]; then
  dap_pane_id="$(split_pane)"
  set_pane_id "$dap_pane_id"
  send_command "$dap_pane_id" "export PROMPT_COMMAND= ; set +o history"
else
  send_interrupt "$dap_pane_id"
  send_interrupt "$dap_pane_id"
fi

send_command "$dap_pane_id" "$command"
