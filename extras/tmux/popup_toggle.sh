#!/usr/bin/env bash

# Arguments
SESSION_NAME="$1"
COMMAND="$2"
USE_ID="$3" # Set to "true" if you want path-specific sessions

# Logic to determine unique session ID
if [ "$USE_ID" = "true" ]; then
    POPUP_ID=$(tmux display-message -p "#{pane_current_path}")
    TARGET_SESSION="${SESSION_NAME}_${POPUP_ID}"
else
    TARGET_SESSION="$SESSION_NAME"
fi

# Toggle Logic
if [ "#{session_name}" = "$SESSION_NAME" ]; then
    tmux detach-client
else
    tmux popup -d "#{pane_current_path}" -xC -yC -w70% -h90% \
        -E "TMUX_RESURRECT_DEACTIVATE=1 tmuxattach $SESSION_NAME \"$TARGET_SESSION\" $COMMAND \"source-file $HOME/.tmux-popup.conf\""
fi
