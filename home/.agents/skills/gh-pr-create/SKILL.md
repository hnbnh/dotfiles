---
name: gh-pr-create
description: Use when asked to open or create a GitHub pull request for the current branch
---

# Create Pull Request

## Overview

Draft the PR title and description, then hand the user the commands that publish it. You run read-only commands only; the user runs `git push` and `gh pr create`.

## Steps

1. **Check the branch (read-only)**
   - `git status -sb` shows whether the branch has an upstream and unpushed commits.

2. **Draft the PR description**
   - Draft a **concise** PR description using the `gh-pr-describe` skill.
   - Extract the ticket id from the head branch and draft a title (see PR Title below).

3. **Confirm with the human (REQUIRED — hard gate)**
   - Show the drafted title and description to the human.
   - **STOP.** Wait for explicit approval.
   - If the human requests edits, revise, show the updated draft, and again STOP for explicit approval.

4. **Hand off the commands**
   - Reply with this block for the user to paste, or run here with a `!` prefix. Drop the `git push` line when step 1 shows the branch pushed and up to date. The quoted `'EOF'` keeps backticks in the body intact.

     ```
     git push -u origin HEAD &&
     gh pr create --draft --base <base> --title "<approved title>" --body-file - <<'EOF'
     <approved body>
     EOF
     ```

   - Add the compare URL, `https://github.com/<owner>/<repo>/compare/<base>...<branch>?expand=1`, for creating it in the browser with "Create draft pull request".
   - Always a **draft** PR — never ready-for-review.
   - Once the user says it's done, run `gh pr view --json url,isDraft` and return the PR URL.

## Who Runs What

| You | The user |
|---|---|
| `git status`, `git log`, `git diff`, `gh pr view`, `gh repo view` | `git push`, `gh pr create`, any other command that changes the remote or GitHub |

The user keeps their column when they approve the draft, are short on time, or ask you to "just push it": answer with the step 4 block. This is the global CLAUDE.md rule that `gh` is read-only, and a push counts.

## PR Title

### Format

```
<type>(optional scope): [<optional ticket>] - <description>

[optional body]
```

### Allowed Types

- feat, fix, chore, docs, refactor, test, style, perf

### Example Titles

```
feat(lang): [ABC-123] - add Polish language
chore!: [XYZ-456] - drop support for Node 6
```
