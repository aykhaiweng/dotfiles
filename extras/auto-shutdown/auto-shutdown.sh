#!/bin/bash
# Configuration
IDLE_SECONDS=$((600))
NOW=$(date +%s)

# 1. Check Interactive TTY activity (mtime of pts devices)
# This is more reliable than loginctl IdleHint for headless servers.
LAST_TTY_ACT=$(find /dev/pts -maxdepth 1 -type c -printf "%T@\n" 2>/dev/null | sort -rn | head -n 1 | cut -d. -f1)
[ -z "$LAST_TTY_ACT" ] && LAST_TTY_ACT=0

# 2. Check Tmux activity (if tmux is running)
LAST_TMUX_ACT=0
if pgrep -x "tmux" > /dev/null; then
    # Get the most recent activity across all sessions
    LAST_TMUX_ACT=$(tmux list-sessions -F "#{session_activity}" 2>/dev/null | sort -rn | head -n 1)
    [ -z "$LAST_TMUX_ACT" ] && LAST_TMUX_ACT=0
fi

# 3. Decision Logic: Use the most recent activity from either source
if [ "$LAST_TTY_ACT" -gt "$LAST_TMUX_ACT" ]; then
    LAST_ACT=$LAST_TTY_ACT
else
    LAST_ACT=$LAST_TMUX_ACT
fi

# If no activity at all (rare), safety abort
if [ "$LAST_ACT" -eq 0 ]; then
    echo "No system activity detected. Safety abort."
    return 0
fi

IDLE_TIME=$((NOW - LAST_ACT))

if [ "$IDLE_TIME" -lt "$IDLE_SECONDS" ]; then
    echo "Recent activity detected ($((IDLE_TIME))s ago). Aborting shutdown."
    exit 0
fi

# 4. Final Safety: Check if an 'inhibit' lock exists
if systemd-inhibit --list | grep -q "idle"; then
    echo "Shutdown inhibited by a running process."
    return 0
fi

echo "System has been idle for ${IDLE_TIME}s. Proceeding to shutdown..."
sudo poweroff
