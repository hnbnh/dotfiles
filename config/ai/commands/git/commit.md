# Create a commit with a detailed message

## Overview

### DO NOT

- DO NOT add any files using `git add`
- DO NOT add any ads such as "Generated with [Claude Code](https://claude.ai/code)"

### DO

- Use `git --no-pager diff --cached` to check for staged changes
- Generate messages for staged files/changes
- Follow conventional commit
- Include message body if user explicitly requests it - otherwise keep commits to subject line only
- If no files are staged, ask user to stage files first before creating a commit

## Format

```
<type>[optional scope]: <description>

[optional body]
```

## Allowed Types

- feat, fix, chore, docs, refactor, test, style, perf

## Example Titles

```
feat(lang): add Polish language
chore!: drop support for Node 6
revert: let us never again speak of the noodle incident
```

## Example with Title and Body

```
fix: prevent racing of requests

- Introduce a request id and a reference to latest request. Dismiss
- incoming responses other than from latest request.
- Remove timeouts which were used to mitigate the racing issue but are obsolete now.
```
