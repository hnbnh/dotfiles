#!/usr/bin/env bash
# Skip the push when HEAD or the open PR already carries this exact set of gitlinks.
set -euo pipefail

: "${PR_BRANCH:?}"
: "${RUNNER_TEMP:?}"
: "${GITHUB_OUTPUT:?}"

worktree_gitlinks() {
  git submodule status | sed 's/^[-+U]//' | awk '{ print $2, $1 }' | sort
}

ref_gitlinks() {
  git ls-tree -r "$1" | awk '$2 == "commit" { print $4, $3 }' | sort
}

submodule_url() {
  local name
  name=$(git config -f .gitmodules --get-regexp '\.path$' | awk -v path="$1" '$2 == path { sub(/\.path$/, "", $1); print $1 }')
  git config -f .gitmodules --get "${name}.url"
}

skip() {
  echo "skip=true" >>"$GITHUB_OUTPUT"
  echo "No push needed: $1"
  exit 0
}

desired=$(worktree_gitlinks)

[[ $desired == "$(ref_gitlinks HEAD)" ]] && skip "every submodule is already at its latest upstream commit"

# Gate on an open PR, not the branch: a leftover branch from a merged/closed PR must reopen one.
if [[ $(gh pr view "$PR_BRANCH" --json state --jq .state 2>/dev/null) == OPEN ]]; then
  git fetch --quiet origin "$PR_BRANCH"
  [[ $desired == "$(ref_gitlinks FETCH_HEAD)" ]] && skip "the open PR on $PR_BRANCH already carries this exact update"
fi

{
  echo 'Automated submodule update to latest remote versions.'
  echo
  echo '| Submodule | Change |'
  echo '| --- | --- |'
  join <(ref_gitlinks HEAD) <(echo "$desired") | while read -r path old new; do
    [[ $old == "$new" ]] && continue
    url=$(submodule_url "$path")
    echo "| \`${path}\` | [\`${old:0:7}...${new:0:7}\`](${url%.git}/compare/${old}...${new}) |"
  done
} | tee "$RUNNER_TEMP/pr-body.md"

echo "skip=false" >>"$GITHUB_OUTPUT"
