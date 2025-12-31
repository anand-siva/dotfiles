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
POPUP_WINDOW_NAME="scratch"
POPUP_NAME="popup-$(basename "$pane_path" | tr -cd 'a-zA-Z0-9-')"

# If we're already in a popup session (named "popup-*"), toggle within it.
if [[ "$session_name" == popup-* ]]; then
  if [[ "$window_name" == "$POPUP_WINDOW_NAME" ]]; then
    tmux detach-client
  else
    tmux select-window -t "$session_name:$POPUP_WINDOW_NAME" 2>/dev/null ||
      tmux new-window -t "$session_name" -n "$POPUP_WINDOW_NAME" -c "$HOME" "$SCRATCH_CMD"
  fi
else
  # Ensure session + window exist
  tmux has-session -t "$POPUP_NAME" 2>/dev/null ||
    tmux new-session -d -s "$POPUP_NAME" -n "$POPUP_WINDOW_NAME" -c "$HOME" "$SCRATCH_CMD"

  tmux select-window -t "$POPUP_NAME:$POPUP_WINDOW_NAME" 2>/dev/null ||
    tmux new-window -t "$POPUP_NAME" -n "$POPUP_WINDOW_NAME" -c "$HOME" "$SCRATCH_CMD"

  # Open popup attached to the session
  tmux display-popup -xC -yC -w "$popup_w" -h "$popup_h" \
    -E "env -u TMUX tmux attach-session -t $POPUP_NAME"
fi
