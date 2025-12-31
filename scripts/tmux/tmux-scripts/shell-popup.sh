#!/usr/bin/env bash
# Toggle a shell popup for the current tmux pane.
# Args:
#   $1 = pane_current_path
#   $2 = session_name
#   $3 = window_name
#   $4 = popup_w (optional, default 95%)
#   $5 = popup_h (optional, default 90%)

pane_path=$1
session_name=$2
window_name=$3
popup_w=${4:-95%}
popup_h=${5:-90%}

POPUP_WINDOW_NAME="${POPUP_WINDOW_NAME:-shell}"
POPUP_NAME="popup-$(basename "$pane_path" | tr -cd 'a-zA-Z0-9-')"

# Pick a shell command. Prefer user's shell; fall back safely.
SHELL_BIN="${SHELL:-/bin/bash}"

# Use an interactive login shell if possible (nice for env/init).
if command -v zsh >/dev/null 2>&1 && [[ -f "$HOME/.zshrc" ]]; then
  SHELL_CMD="zsh -i"
else
  SHELL_CMD="bash -l"
fi

# If we're already in a popup session (named "popup-*"), toggle within it.
if [[ "$session_name" == popup-* ]]; then
  if [[ "$window_name" == "$POPUP_WINDOW_NAME" ]]; then
    tmux detach-client
  else
    tmux select-window -t "$session_name:$POPUP_WINDOW_NAME" 2>/dev/null ||
      tmux new-window -t "$session_name" -n "$POPUP_WINDOW_NAME" -c "$pane_path" $SHELL_CMD
  fi
else
  # From a normal session: ensure popup session + shell window exist
  tmux has-session -t "$POPUP_NAME" 2>/dev/null ||
    tmux new-session -d -s "$POPUP_NAME" -c "$pane_path" -n "$POPUP_WINDOW_NAME" $SHELL_CMD

  tmux select-window -t "$POPUP_NAME:$POPUP_WINDOW_NAME" 2>/dev/null ||
    tmux new-window -t "$POPUP_NAME" -n "$POPUP_WINDOW_NAME" -c "$pane_path" $SHELL_CMD

  # Open popup attached to that session
  tmux display-popup -d "$pane_path" -xC -yC -w "$popup_w" -h "$popup_h" \
    -E "env -u TMUX tmux attach-session -t $POPUP_NAME"
fi
