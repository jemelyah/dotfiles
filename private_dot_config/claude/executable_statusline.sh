#!/bin/bash
# Claude Code status line: model | context % (colored) | dir basename
input=$(cat)
model=$(echo "$input" | jq -r '.model.display_name // "?"')
dir=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // empty')
pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

out="$model"
if [ -n "$pct" ]; then
  n=$(printf '%.0f' "$pct")
  if [ "$n" -gt 75 ]; then c='\033[31m'
  elif [ "$n" -ge 50 ]; then c='\033[33m'
  else c='\033[0m'; fi
  out="$out | $(printf "${c}%s%%\033[0m" "$n")"
fi
[ -n "$dir" ] && out="$out | ${dir##*/}"
printf '%b\n' "$out"
