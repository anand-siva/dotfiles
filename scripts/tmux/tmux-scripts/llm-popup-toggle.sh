#!/usr/bin/env bash
# Toggle the LLM popup for the current tmux pane.
# Args:
#   $1 = pane_current_path
#   $2 = session_name
#   $3 = window_name

pane_path=$1
session_name=$2
window_name=$3
popup_w=${4:-95%}
popup_h=${5:-90%}

LLM_ASSISTANT="${LLM_ASSISTANT:-codex}" # set to codex by default
POPUP_NAME="popup-$(basename "$pane_path" | tr -cd "a-zA-Z0-9-")"

# If we're already in a popup session (named "popup-*"), toggle within it.
if [[ "$session_name" == popup-* ]]; then
  if [[ "$window_name" == "$LLM_ASSISTANT" ]]; then
    tmux detach-client
  else
    tmux select-window -t "$session_name:$LLM_ASSISTANT" 2>/dev/null ||
      tmux new-window -t "$session_name" -n "$LLM_ASSISTANT" -c "$pane_path" "$LLM_ASSISTANT"
  fi
else
  # From a normal session: ensure the popup session + LLM window exist,
  # then open a popup attached to that session.
  tmux has-session -t "$POPUP_NAME" 2>/dev/null ||
    tmux new-session -d -s "$POPUP_NAME" -c "$pane_path" -n "$LLM_ASSISTANT" "$LLM_ASSISTANT"

  tmux select-window -t "$POPUP_NAME:$LLM_ASSISTANT" 2>/dev/null ||
    tmux new-window -t "$POPUP_NAME" -n "$LLM_ASSISTANT" -c "$pane_path" "$LLM_ASSISTANT"

  tmux display-popup -d "$pane_path" -xC -yC -w "$popup_w" -h "$popup_h" \
    -E "env -u TMUX tmux attach-session -t $POPUP_NAME"
fi
