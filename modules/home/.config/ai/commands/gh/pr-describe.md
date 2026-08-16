# Generate PR Description

Generate a **concise** PR description based on git changes.

## Steps

- If a PR id is provided, use `gh pr view <PR_ID> --json title,body`; otherwise use `git diff main...HEAD`.

1. Review the commits and code changes in the branch.
2. Understand the purpose: what problem is solved, what changed, and any breaking changes.
3. Generate a description using the template below.

## Conciseness rules

- Summary: 1-2 sentences. Lead with the "why".
- Changes: 3-6 bullets max. Group related edits; skip file-by-file narration.
- Omit any section that does not apply (do not leave empty headings).
- No filler, no restating the diff. If a bullet adds nothing, cut it.

## Template

```markdown
## Summary

[1-2 sentences: what this PR does and why.]

## Changes

- [Significant change and its reason]
- [Group related edits together]

## Test Plan

- [ ] [How to verify it works]

## Breaking Changes

[Only if applicable — list them.]
```

## Example

```markdown
## Summary

Restore filetype after loading a session by persisting buffer-local options, fixing lost syntax highlighting on resume.

## Changes

- Add `localoptions` to `sessionoptions` so filetype is saved per buffer
- Drop the manual `filetype detect` autocmd it replaces

## Test Plan

- [ ] Open a file, `:mksession`, restart nvim, `:source` — filetype is correct
```

Return the generated description text only.
