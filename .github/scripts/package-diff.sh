#!/usr/bin/env bash
# Usage: package-diff.sh before.json after.json
# Print a markdown table of packages whose version changed between two
# package-versions.sh snapshots, or a one-line note when nothing changed.
set -euo pipefail

jq -r -n --slurpfile b "$1" --slurpfile a "$2" '
  $b[0] as $before | $a[0] as $after |
  (($before + $after) | keys)
  | map({ name: ., before: $before[.], after: $after[.] })
  | map(select(.before != .after))
  | if length == 0 then
      "No declared package changed version."
    else
      "| Package | Before | After |",
      "| --- | --- | --- |",
      (.[] | "| \(.name) | \(.before // "(new)") | \(.after // "(removed)") |")
    end
'
