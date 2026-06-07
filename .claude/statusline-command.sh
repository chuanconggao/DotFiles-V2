#!/usr/bin/env bash
# Claude Code status line: cwd | context window | session tokens | session name

# --- Colors ---
reset=$'\e[0m'
bright_white=$'\e[97m'   # default color of \e[0m varies across environments (iTerm vs. Claude Code)
cwd_color=$'\e[1;34m'    # bold blue, matches zsh prompt %F{blue}%B
ctx_green=$'\e[32m'
ctx_yellow=$'\e[33m'
ctx_red=$'\e[31m'

# --- Input ---
input=$(cat)
cwd=$(echo "$input" | jq -r '.cwd')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
context_size=$(echo "$input" | jq -r '.context_window.context_window_size // empty')
total_cost=$(echo "$input" | jq -r '.cost.total_cost_usd // empty')

# --- Build parts ---

# cwd
short_cwd="${cwd/#$HOME/\~}"
git_prompt=$(cd "$cwd" && print_git_prompt 2>/dev/null)
if [ -n "$git_prompt" ]; then
    cwd_part="${cwd_color}${short_cwd}${reset} ${bright_white}(${git_prompt}${bright_white})${reset}"
else
    cwd_part="${cwd_color}${short_cwd}${reset}"
fi

# context window
if [ -n "$context_size" ]; then
    used_rounded=$(printf "%.0f" "${used_pct:-0}")
    context_k=$(( context_size / 1000 ))
    if [ "$context_k" -ge 1000 ]; then
        context_size_label="$(( context_k / 1000 ))M"
    else
        context_size_label="${context_k}K"
    fi
    if [ "$used_rounded" -lt 60 ]; then
        ctx_color="$ctx_green"
    elif [ "$used_rounded" -lt 80 ]; then
        ctx_color="$ctx_yellow"
    else
        ctx_color="$ctx_red"
    fi
    context_part="${ctx_color}${used_rounded}% of ${context_size_label} context${reset}"
else
    context_part=""
fi

# session cost
if [ -n "$total_cost" ]; then
    cost_fmt=$(awk -v c="$total_cost" 'BEGIN{printf "$%.2f", c}')
    cost_color=$(awk -v c="$total_cost" -v y="$ctx_yellow" -v r="$ctx_red" -v rst="$reset" \
        'BEGIN{ if (c >= 5) printf "%s", r; else if (c >= 1) printf "%s", y }')
    session_tokens_part="${cost_color}${cost_fmt}${reset}"
else
    session_tokens_part=""
fi

# --- Assemble ---
parts=("$cwd_part")
[ -n "$context_part" ]        && parts+=("$context_part")
[ -n "$session_tokens_part" ] && parts+=("$session_tokens_part")

printf '%s' "${parts[0]}"
for part in "${parts[@]:1}"; do
  printf ' | %s' "$part"
done
printf '\n'
