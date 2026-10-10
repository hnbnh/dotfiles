---
name: gh-pr-create
description: Use when asked to open or create a GitHub pull request for the current branch
---

# Create Pull Request

## Overview

Create a well-structured pull request with proper description.

## Steps

1. **Prepare branch**
   - Push branch to remote

2. **Draft the PR description**
   - Draft a **concise** PR description using the `gh-pr-describe` skill.
   - Extract the ticket id from the head branch and draft a title (see PR Title below).

3. **Confirm with the human (REQUIRED — hard gate)**
   - Show the drafted title and description to the human.
   - **STOP.** Wait for explicit approval before creating the PR.
   - If the human requests edits, revise, show the updated draft, and again STOP for explicit approval.
   - Do NOT run `gh pr create` until the human approves.

4. **Create the PR as a DRAFT**
   - Create the PR using `gh pr create --draft` with the approved title and description.
   - Always create a **draft** PR — never a ready-for-review PR.
   - Return the PR URL when complete.

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
