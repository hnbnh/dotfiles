# Generate PR Description

Generate a comprehensive PR description based on git changes.

## Steps

- Review all code changes using `git diff main...HEAD`

1. Review all commits in the PR/branch changes
2. Review all code changes thoroughly
3. Analyze the changes to understand:
   - The purpose and motivation
   - What problems are being solved
   - What features are being added
   - Any breaking changes or important updates

4. Generate a comprehensive PR description with the following structure:

```markdown
## Summary

[1-3 sentences explaining what this PR does and why it's needed]

## Changes

- [Bullet point for each significant change]
- [Focus on what changed and why, not just file names]
- [Group related changes together]

## Test Plan

- [ ] [How to verify the changes work]
- [ ] [Steps to test the functionality]
- [ ] [Any edge cases to check]

## Breaking Changes

[Only include this section if there are breaking changes]

- [List any breaking changes]

## Screenshots/Demos

[Only include this section if UI/visual changes were made]
[Note if screenshots are needed but not provided]
```

5. Make the description:
   - Clear and comprehensive
   - Focused on the "why" not just the "what"
   - Well-organized with proper markdown
   - Include relevant technical details
   - Highlight any important considerations

Return the generated description text.
