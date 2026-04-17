#!/usr/bin/env bash
# Claude Code Status Line - TokyoNight theme
# Receives JSON via stdin

input=$(cat)

# ── TokyoNight color palette (ANSI 256-color) ──────────────────────────────
C_RESET="\033[0m"
C_BLUE="\033[38;5;111m"
C_GREEN="\033[38;5;107m"
C_YELLOW="\033[38;5;179m"
C_ORANGE="\033[38;5;209m"
C_RED="\033[38;5;210m"
C_MAGENTA="\033[38;5;141m"
C_DIM="\033[38;5;60m"
C_FG="\033[38;5;189m"

SEP="${C_DIM} │ ${C_RESET}"

# ── 1. Model ────────────────────────────────────────────────────────────────
model=$(echo "$input" | jq -r '.model.display_name // "unknown"')

# ── 1b. Effort level ────────────────────────────────────────────────────────
effort=$(echo "$input" | jq -r '.effort_level // .effortLevel // empty')
if [ -z "$effort" ]; then
  effort=$(jq -r '.effortLevel // empty' ~/.claude/settings.json 2>/dev/null)
fi
case "$effort" in
  low)    ec="$C_DIM"    ;;
  medium) ec="$C_YELLOW" ;;
  high)   ec="$C_ORANGE" ;;
  xhigh)  ec="$C_RED"    ;;
  *)      ec="$C_FG"     ;;
esac
if [ -n "$effort" ]; then
  effort_out="${C_DIM}e:${C_RESET}${ec}${effort}${C_RESET}"
else
  effort_out=""
fi

# ── 2. Context window usage + progress bar ──────────────────────────────────
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
if [ -n "$used_pct" ]; then
  used_int=$(printf "%.0f" "$used_pct")
  bar_len=10
  filled=$(( used_int * bar_len / 100 ))
  empty_bar=$(( bar_len - filled ))
  bar=""
  for i in $(seq 1 "$filled"); do bar="${bar}█"; done
  for i in $(seq 1 "$empty_bar"); do bar="${bar}░"; done

  if [ "$used_int" -ge 80 ]; then
    bar_color="$C_RED"
  elif [ "$used_int" -ge 50 ]; then
    bar_color="$C_YELLOW"
  else
    bar_color="$C_GREEN"
  fi
  ctx_str="${bar_color}${bar}${C_DIM} ${used_int}%${C_RESET}"
else
  ctx_str="${C_DIM}ctx:n/a${C_RESET}"
fi

# ── 3. Rate limits ─────────────────────────────────────────────────────────
five_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
week_pct=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
rate_out=""
if [ -n "$five_pct" ]; then
  five_int=$(printf "%.0f" "$five_pct")
  if [ "$five_int" -ge 80 ]; then rc="$C_RED"; elif [ "$five_int" -ge 50 ]; then rc="$C_ORANGE"; else rc="$C_GREEN"; fi
  rate_out="${C_DIM}5h:${C_RESET}${rc}${five_int}%${C_RESET}"
fi
if [ -n "$week_pct" ]; then
  week_int=$(printf "%.0f" "$week_pct")
  if [ "$week_int" -ge 80 ]; then wc_color="$C_RED"; elif [ "$week_int" -ge 50 ]; then wc_color="$C_ORANGE"; else wc_color="$C_GREEN"; fi
  [ -n "$rate_out" ] && rate_out="${rate_out} ${C_DIM}7d:${C_RESET}${wc_color}${week_int}%${C_RESET}" \
                     || rate_out="${C_DIM}7d:${C_RESET}${wc_color}${week_int}%${C_RESET}"
fi
[ -z "$rate_out" ] && rate_out="${C_DIM}rate:n/a${C_RESET}"

# ── 4. Current working directory ────────────────────────────────────────────
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // "?"')
cwd_short="${cwd/#$HOME/~}"
if [ ${#cwd_short} -gt 40 ]; then
  cwd_short="…${cwd_short: -38}"
fi
cwd_out="${C_BLUE}${cwd_short}${C_RESET}"

# ── 5. Git status ───────────────────────────────────────────────────────────
git_out=""
if git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
  branch=$(git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null \
           || git -C "$cwd" rev-parse --short HEAD 2>/dev/null \
           || echo "detached")
  staged=$(git -C "$cwd" diff --cached --name-only --no-optional-locks 2>/dev/null | wc -l | tr -d ' ')
  unstaged=$(git -C "$cwd" diff --name-only --no-optional-locks 2>/dev/null | wc -l | tr -d ' ')
  untracked=$(git -C "$cwd" ls-files --others --exclude-standard 2>/dev/null | wc -l | tr -d ' ')

  git_info="${C_MAGENTA}${branch}${C_RESET}"
  changes=""
  [ "$staged"    -gt 0 ] && changes="${changes}${C_GREEN}+${staged}${C_RESET}"
  [ "$unstaged"  -gt 0 ] && changes="${changes}${C_YELLOW}~${unstaged}${C_RESET}"
  [ "$untracked" -gt 0 ] && changes="${changes}${C_RED}?${untracked}${C_RESET}"
  [ -n "$changes" ] && git_info="${git_info} ${changes}"
  git_out="$git_info"
else
  git_out="${C_DIM}no git${C_RESET}"
fi

# ── Assemble ─────────────────────────────────────────────────────────────────
# model [│ effort] │ context bar │ rate │ dir │ git
model_seg="${C_FG}${model}${C_RESET}"
[ -n "$effort_out" ] && model_seg="${model_seg}${SEP}${effort_out}"
echo -e "${model_seg}${SEP}${ctx_str}${SEP}${rate_out}${SEP}${cwd_out}${SEP}${git_out}"
