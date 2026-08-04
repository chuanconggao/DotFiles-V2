#!/usr/bin/env bash
# Claude Code status line: cwd | context window | session tokens | session name

# --- Colors ---
reset=$'\e[0m'
bright_white=$'\e[97m'   # default color of \e[0m varies across environments (iTerm vs. Claude Code)
cwd_color=$'\e[1;34m'    # bold blue, matches zsh prompt %F{blue}%B
ctx_green=$'\e[32m'
ctx_yellow=$'\e[33m'
ctx_red=$'\e[31m'

pct_color() {
    local pct="$1"
    if [ "$pct" -lt 60 ]; then
        echo "$ctx_green"
    elif [ "$pct" -lt 80 ]; then
        echo "$ctx_yellow"
    else
        echo "$ctx_red"
    fi
}

# --- Input ---
input=$(cat)
cwd=$(echo "$input" | jq -r '.cwd')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
context_size=$(echo "$input" | jq -r '.context_window.context_window_size // empty')
total_cost=$(echo "$input" | jq -r '.cost.total_cost_usd // empty')
model_name=$(echo "$input" | jq -r '.model.display_name // empty')
effort_level=$(echo "$input" | jq -r '.effort.level // empty')
five_hour_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
seven_day_pct=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')

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
    ctx_color=$(pct_color "$used_rounded")
    context_part="${ctx_color}${used_rounded}%${reset} of ${context_size_label}"
else
    context_part=""
fi

# model / effort
if [ -n "$model_name" ]; then
    model_label="${model_name#Claude }"
    case "$model_name" in
        *Haiku*|*Sonnet*) model_color="$ctx_green" ;;
        *Opus*)           model_color="$ctx_yellow" ;;
        *Fable*)          model_color="$ctx_red" ;;
        *)                model_color="" ;;
    esac
    if [ -n "$model_color" ]; then
        model_part="${model_color}${model_label}${reset}"
    else
        model_part="$model_label"
    fi
    if [ -n "$effort_level" ] && [ "$effort_level" != "medium" ]; then
        case "$effort_level" in
            low|medium) effort_color="$ctx_green" ;;
            high)       effort_color="$ctx_yellow" ;;
            *)          effort_color="$ctx_red" ;;
        esac
        model_part="${model_part} (${effort_color}${effort_level}${reset})"
    fi
else
    model_part=""
fi

# session cost
if [ -n "$total_cost" ]; then
    cost_fmt=$(awk -v c="$total_cost" 'BEGIN{printf "%.2f", c}')
    # rate_limits only appears for subscription plans (Pro/Max/Team); on those
    # total_cost_usd is a notional token-value, not real money, so skip coloring it
    if [ -n "$five_hour_pct" ] || [ -n "$seven_day_pct" ]; then
        cost_color=""
    else
        cost_color=$(awk -v c="$total_cost" -v y="$ctx_yellow" -v r="$ctx_red" -v rst="$reset" \
            'BEGIN{ if (c >= 5) printf "%s", r; else if (c >= 1) printf "%s", y }')
    fi
    session_tokens_part="${cost_color}${cost_fmt}${reset}"
else
    session_tokens_part=""
fi

# usage limits
usage_bits=()
if [ -n "$five_hour_pct" ]; then
    five_hour_rounded=$(printf "%.0f" "$five_hour_pct")
    usage_bits+=("$(pct_color "$five_hour_rounded")${five_hour_rounded}%${reset} of 5h")
fi
if [ -n "$seven_day_pct" ]; then
    seven_day_rounded=$(printf "%.0f" "$seven_day_pct")
    usage_bits+=("$(pct_color "$seven_day_rounded")${seven_day_rounded}%${reset} of 7d")
fi
usage_part=""
for bit in "${usage_bits[@]}"; do
    if [ -z "$usage_part" ]; then
        usage_part="$bit"
    else
        usage_part="${usage_part} : ${bit}"
    fi
done

# --- Assemble ---
parts=("$cwd_part")
[ -n "$model_part" ]          && parts+=("🧠 $model_part")
[ -n "$context_part" ]        && parts+=("📜 $context_part")
[ -n "$usage_part" ]          && parts+=("⏳ $usage_part")
[ -n "$session_tokens_part" ] && parts+=("💰 $session_tokens_part")

printf '%s' "${parts[0]}"
for part in "${parts[@]:1}"; do
  printf ' | %s' "$part"
done
printf '\n'
