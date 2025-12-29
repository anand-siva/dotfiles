#!/usr/bin/env bash
# Persistent scratch-pad popup (HOME-backed file)

pane_path=$1
session_name=$2
window_name=$3
scratch_name=${4:-scratch.md} # default filename
popup_w=${5:-95%}
popup_h=${6:-90%}

SCRATCH_FILE="$HOME/$scratch_name"
SCRATCH_CMD="nvim \"$SCRATCH_FILE\""
POPUP_NAME="scratch-$(basename "$scratch_name" | tr -cd 'a-zA-Z0-9-')"

# If already inside scratch popup session, toggle close / focus
if [[ "$session_name" == "$POPUP_NAME" ]]; then
  if [[ "$window_name" == "scratch" ]]; then
    tmux detach-client
  else
    tmux select-window -t "$POPUP_NAME:scratch"
  fi
else
  # Ensure session + window exist
  tmux has-session -t "$POPUP_NAME" 2>/dev/null ||
    tmux new-session -d -s "$POPUP_NAME" -n scratch -c "$HOME" "$SCRATCH_CMD"

  tmux select-window -t "$POPUP_NAME:scratch" 2>/dev/null ||
    tmux new-window -t "$POPUP_NAME" -n scratch -c "$HOME" "$SCRATCH_CMD"

  # Open popup attached to the session
  tmux display-popup -xC -yC -w "$popup_w" -h "$popup_h" \
    -E "env -u TMUX tmux attach-session -t $POPUP_NAME"
fi
