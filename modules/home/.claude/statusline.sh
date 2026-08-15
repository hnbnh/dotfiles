#!/bin/bash

input=$(cat)

model=$(echo "$input" | jaq -r '.model.display_name')
cwd=$(echo "$input" | jaq -r '.workspace.current_dir')
used=$(echo "$input" | jaq -r '.context_window.used_percentage // empty')

branch=$(git -C "$cwd" -c core.filesRefLockTimeout=0 -c core.packedRefsTimeout=0 branch --show-current 2>/dev/null || echo 'no branch')

if [ -n "$used" ]; then
  context=$(printf "%.0f%% used" "$used")
else
  context='N/A'
fi

blue=$(printf '\033[38;2;137;180;250m')
green=$(printf '\033[38;2;166;227;161m')
yellow=$(printf '\033[38;2;249;226;175m')
reset=$(printf '\033[0m')

printf "${blue} %s${reset} | ${green} %s${reset} | ${yellow} %s${reset}\n" "🤖 $model" " $branch" "ctx: $context"
