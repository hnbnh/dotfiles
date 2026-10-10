---
name: gh-pr-redescribe
description: Use when asked to update or rewrite the description of an existing GitHub pull request
---

# Update PR Description

## Steps

- If user does not provide PR link, ask for it.

1. Draft the PR description using the `gh-pr-describe` skill.
2. Use `gh pr edit <PR_ID> --body <PR_DESCRIPTION>` to update the PR description.
