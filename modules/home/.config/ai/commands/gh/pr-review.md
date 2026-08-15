# Review PR and Suggest Edits

## Overview

Review a GitHub pull request, analyze the code changes, generate improvement suggestions,
and let the user select which comments to submit.

## Steps

- If user does not provide PR link or PR number, ask for it.

1. **Fetch PR details**
   - Use `gh pr view <PR_NUMBER> --json number,title,body,author,files,additions,deletions,url` to get PR metadata
   - Use `gh pr diff <PR_NUMBER>` to get the full diff
   - Display a summary of the PR to the user:
     - PR title and author
     - Files changed count
     - Lines added/removed

2. **Analyze code changes**
   - Review all files and changes in the diff thoroughly
   - Consider:
     - Code quality and best practices
     - Potential bugs or edge cases
     - Performance implications
     - Security concerns
     - Code readability and maintainability
     - Test coverage
     - Documentation needs
     - Type safety issues
     - Consistency with codebase patterns

3. **Generate suggestions**
   - Create a list of actionable suggestions, each containing:
     - File path and line number(s)
     - Issue type (bug, improvement, style, security, performance, etc.)
     - Description of the issue
     - Suggested fix or improvement
     - Severity (critical, high, medium, low)

   - Organize suggestions by:
     - Critical issues first (bugs, security)
     - Then improvements and optimizations
     - Then style and documentation

4. **Present suggestions to user**
   - Display all suggestions in a clear, numbered list
   - For each suggestion show:
     - [#] [Severity] File:line - Issue type
     - Description
     - Suggested fix

   - Use the AskUserQuestion tool to let the user select which suggestions to submit as PR comments
   - Allow multiple selection

5. **Submit selected comments**
   - For each selected suggestion, use the GitHub CLI to post a review comment:
     - Use `gh pr comment <PR_NUMBER> --body "<comment>"` for general comments
     - Use `gh api repos/{owner}/{repo}/pulls/<PR_NUMBER>/comments -f body="<comment>" -f path="<file>" -f line=<line> -f side=RIGHT` for inline comments
   - Format each comment professionally:
     - Clear description of the issue
     - Explanation of why it matters
     - Specific suggestion for improvement
     - Code example if applicable

   - Track which comments were successfully posted
   - Display a summary of submitted comments to the user

6. **Completion summary**
   - Report how many comments were submitted
   - List any errors or issues encountered
   - Provide the PR URL for easy access

## Important Notes

- Be constructive and professional in all suggestions
- Focus on actionable feedback
- Avoid nitpicking on minor style issues unless they impact readability
- Prioritize correctness and security over style
- Consider the PR context and scope when making suggestions
- If the PR already has existing comments, avoid duplicating them
