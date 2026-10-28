#!/bin/bash
# Status line: <cwd> <branch> | <model> <context-usage circle> <tokens used/total> | <5h/7d rate-limit circles> | <session cost>
# All fields degrade gracefully (empty/0) when the corresponding JSON field is absent.

input=$(cat)

cwd=$(echo "$input" | jq -r '.workspace.current_dir // empty')
[ -z "$cwd" ] && cwd="$PWD"

real_cwd=$(cd "$cwd" 2>/dev/null && pwd -P)
[ -z "$real_cwd" ] && real_cwd="$cwd"

# Resolve a path git printed (relative to $cwd, or absolute) to a physical absolute path.
abspath() {
  case "$1" in
    /*) (cd "$1" 2>/dev/null && pwd -P) ;;
    *)  (cd "$cwd/$1" 2>/dev/null && pwd -P) ;;
  esac
}

# Branch + linked-worktree detection in one git call. Everything stays empty when
# not a repo, on any git error, or (for the branch) on a detached HEAD.
branch=""; is_wt=""; wt_top=""; main_root=""
{ IFS= read -r g_head; IFS= read -r g_top; IFS= read -r g_dir; IFS= read -r g_common; } < <(
  git -C "$cwd" --no-optional-locks rev-parse --abbrev-ref HEAD --show-toplevel --git-dir --git-common-dir 2>/dev/null
)
[ "$g_head" != "HEAD" ] && branch="$g_head"
if [ -n "$g_dir" ] && [ -n "$g_common" ]; then
  git_dir_abs=$(abspath "$g_dir"); common_abs=$(abspath "$g_common")
  if [ -n "$git_dir_abs" ] && [ "$git_dir_abs" != "$common_abs" ]; then
    is_wt=1
    wt_top="$g_top"
    main_root="${common_abs%/.git}"   # unchanged when the common dir isn't <root>/.git
  fi
fi

# In a linked worktree show the main repo root plus the cwd's path inside the worktree.
dir="$cwd"
if [ -n "$is_wt" ] && [ "$main_root" != "$common_abs" ]; then
  case "$real_cwd" in
    "$wt_top"|"$wt_top"/*) dir="$main_root${real_cwd#"$wt_top"}" ;;
  esac
fi

# %~ equivalent: collapse $HOME prefix to ~
case "$dir" in
  "$HOME") dir="~" ;;
  "$HOME"/*) dir="~${dir#"$HOME"}" ;;
esac

# OSC 8 hyperlinks (ST-terminated). A status line can't copy on click, so the
# segments link to file:// URLs instead. Control chars are dropped so a hostile
# path can't inject escape sequences; %, space, # and ? are percent-encoded.
file_url() {
  printf 'file://%s' "$(printf '%s' "$1" | tr -d '\000-\037\177' | sed 's/%/%25/g; s/ /%20/g; s/#/%23/g; s/?/%3F/g')"
}
osc_link() { printf '\033]8;;%s\033\\%s\033]8;;\033\\' "$1" "$2"; }

BRANCH_ICON=$'\xee\x82\xa0'       # U+E0A0 (Nerd Font powerline branch)
WORKTREE_ICON=$'\xf3\xb0\x99\x85' # U+F0645 (nf-md-file_tree)

model=$(echo "$input" | jq -r '.model.display_name // empty')

used_tokens=$(echo "$input" | jq -r '.context_window.total_input_tokens // 0')
ctx_size=$(echo "$input" | jq -r '.context_window.context_window_size // 0')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

if [ -z "$used_pct" ]; then
  if [ "$ctx_size" -gt 0 ] 2>/dev/null; then
    used_pct=$(awk -v u="$used_tokens" -v c="$ctx_size" 'BEGIN{printf "%.2f", (u/c)*100}')
  else
    used_pct=0
  fi
fi

# Quarter-fill usage circle plus a trailing space (○ ◔ ◑ ◕ ●), shared by the context indicator
# and the rate-limit indicators below. Single-width glyphs only (no emoji), so
# the width math further down stays correct.
make_bar() {
  local pct="$1" circles=(○ ◔ ◑ ◕ ●) i
  i=$(awk -v p="$pct" 'BEGIN{i=int((p/25)+0.5); if(i<0)i=0; if(i>4)i=4; print i}')
  # Trailing space: these glyphs render tight against the next segment.
  printf '%s ' "${circles[$i]}"
}

bar=$(make_bar "$used_pct")

# Human-readable token counts: plain below 1k, thousands (84k) up to 999k, then millions (1M, 1.5M)
human() {
  awk -v n="$1" 'BEGIN{
    if (n >= 999500) { m = n/1000000; if (m == int(m)) printf "%dM", m; else printf "%.1fM", m }
    else if (n >= 1000) printf "%dk", int((n/1000)+0.5)
    else printf "%d", n+0
  }'
}
tokens_str="$(human "$used_tokens")/$(human "$ctx_size")"

cost_usd=$(echo "$input" | jq -r '.cost.total_cost_usd // empty')
cost_str=""
[ -n "$cost_usd" ] && cost_str=$(printf '$%.2f' "$cost_usd")

YELLOW='\033[33m'
GREEN='\033[32m'
RED='\033[31m'
DIM='\033[2m'
RESET='\033[0m'

# Remaining Claude.ai subscription usage budget (or gateway spend limit) for
# the current model's session, rendered as a bar in the same style as the
# context bar above (same width/glyphs/DIM colour; filled = % used). Omitted
# cleanly when not a subscriber/behind a gateway that reports it.
five_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
week_pct=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
spend_pct=$(echo "$input" | jq -r '.rate_limits.spend_limit.used_percentage // empty')

usage_seg() {
  local label="$1" pct="$2" rem bar color
  rem=$(awk -v u="$pct" 'BEGIN{printf "%.0f", 100-u}')
  bar=$(make_bar "$pct")
  # Colour by % used: green up to 70, yellow up to 90, red above.
  color=$(awk -v u="$pct" -v g="$GREEN" -v y="$YELLOW" -v r="$RED" 'BEGIN{print (u<=70) ? g : (u<=90) ? y : r}')
  printf -v "$3" "${YELLOW}%s${RESET} ${color}%s %s%%${RESET}" "$label" "$bar" "$rem"
}

usage_parts=""
if [ -n "$five_pct" ]; then
  usage_seg "5h" "$five_pct" five_seg
  usage_parts="$five_seg"
fi
if [ -n "$week_pct" ]; then
  usage_seg "7d" "$week_pct" week_seg
  [ -n "$usage_parts" ] && usage_parts="$usage_parts  "
  usage_parts="${usage_parts}${week_seg}"
fi
if [ -z "$usage_parts" ] && [ -n "$spend_pct" ]; then
  usage_seg "spend" "$spend_pct" spend_seg
  usage_parts="$spend_seg"
fi

cwd_url=$(file_url "$real_cwd")
make_dir_c() { printf -v dir_c "${YELLOW}%s${RESET}" "$(osc_link "$cwd_url" "$dir")"; }
make_dir_c

branch_c=""
if [ -n "$branch" ]; then
  if [ -n "$is_wt" ]; then
    printf -v branch_c " ${GREEN}%s${RESET}" "$(osc_link "$(file_url "$wt_top")" "$WORKTREE_ICON $branch")"
  else
    printf -v branch_c " ${GREEN}%s %s${RESET}" "$BRANCH_ICON" "$branch"
  fi
fi

RED='\033[31m'

# Per-model context colour thresholds (tokens): green <= warn, yellow <= crit, red above.
# Models not listed keep the default look (DIM bar, uncoloured token count).
model_id=$(echo "$input" | jq -r '.model.id // empty')
warn=""; crit=""
case "$model_id" in
  *sonnet-5-5*) warn=90000;  crit=100000 ;;
  *opus-5-5*)   warn=400000; crit=500000 ;;
esac

# Model name colour: Opus 5.5 yellow, Sonnet 5.5 green, Fable 5.1 light blue;
# other models keep the default colour.
LIGHT_BLUE='\033[96m'
case "$model_id" in
  *opus-5-5*)   model_color="$YELLOW" ;;
  *sonnet-5-5*) model_color="$GREEN" ;;
  *fable-5-1*)  model_color="$LIGHT_BLUE" ;;
  *)            model_color="" ;;
esac
if [ -n "$model_color" ]; then
  printf -v model_c "${model_color}%s${RESET}" "$model"
else
  model_c="$model"
fi

if [ -n "$warn" ]; then
  if   [ "${used_tokens%.*}" -le "$warn" ]; then ctx_color="$GREEN"
  elif [ "${used_tokens%.*}" -le "$crit" ]; then ctx_color="$YELLOW"
  else ctx_color="$RED"
  fi
  printf -v mid_c " | %s ${ctx_color}%s %s${RESET}" "$model_c" "$bar" "$tokens_str"
else
  printf -v mid_c " | %s ${DIM}%s${RESET} %s" "$model_c" "$bar" "$tokens_str"
fi

usage_c=""
[ -n "$usage_parts" ] && printf -v usage_c " | %s" "$usage_parts"

cost_c=""
[ -n "$cost_str" ] && printf -v cost_c " | %s" "$cost_str"

# Truncate the cwd (keep the tail, leading "…") only when the whole line would
# be wider than the terminal. Widths are measured on the ANSI-stripped text in
# a UTF-8 locale so the circle glyphs and "…" count as one column each.
cols="${COLUMNS:-}"
[ -z "$cols" ] && cols=$(tput cols 2>/dev/null </dev/tty)
case "$cols" in ''|*[!0-9]*) cols=80 ;; esac

export LC_ALL=en_US.UTF-8
rest_plain=$(printf '%s' "$branch_c$mid_c$usage_c$cost_c" | sed -e $'s/\033\\[[0-9;]*m//g' -e $'s/\033]8;;[^\033]*\033\\\\//g')
total=$(( ${#dir} + ${#rest_plain} ))
if [ "$total" -gt "$cols" ]; then
  keep=$(( cols - ${#rest_plain} - 1 ))   # -1 for the leading "…"
  [ "$keep" -lt 1 ] && keep=1
  if [ "$keep" -lt "${#dir}" ]; then
    dir="…${dir: -$keep}"
    make_dir_c
  fi
fi

printf "%s%s%s%s%s" "$dir_c" "$branch_c" "$mid_c" "$usage_c" "$cost_c"
