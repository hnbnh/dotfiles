# Create Pull Request

## Overview

Create a well-structured pull request with proper description.

## Steps

1. **Prepare branch**
   - Push branch to remote

2. **Write PR description**
   - Refer to the instructions located in this file to draft a comprehensive PR description: @~/.config/ai/commands/gh/pr-describe.md

3. **Set up PR**
   - Extract ticket id from head branch
   - Create PR with descriptive title
   - Apply conventional commit rules to PR title
   - Create the PR using `gh pr create` with the drafted title and description
   - Return the PR URL when complete

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
