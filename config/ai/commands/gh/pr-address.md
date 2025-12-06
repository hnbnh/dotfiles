# Address PR comments

## Overview

Process outstanding reviewer feedback, apply required fixes, and draft clear
responses for each GitHub pull-request comment.

## Steps

- If user does not provide PR link, ask for it.

1. **Sync and audit comments**
   - Run bash command `gh_get_unresolved_comments <owner> <repo> <pr id>` to fetch unresolved review comments
     - If the above command fails, stop here
   - Parse and display the unresolved comment list to the user, showing:
     - Author
     - File path and line number
     - Comment body (first 100 chars or full text)

2. **User selects comments to address**
   - Present the comment list to the user
   - Think hard and suggest which comments to address or answer (explanations/clarifications only)
   - User will make final decision
   - Group selected comments by affected files or themes

3. **Plan resolutions**
   - For each selected comment, list the requested code edits
   - Identify clarifications or additional context you must provide
   - Note any dependencies or blockers before implementing changes

4. **Implement fixes**
   - Apply targeted updates addressing one comment thread at a time
   - Run relevant tests or linters after impactful changes

5. **Draft responses**
   - Summarize the action taken or reasoning provided for each comment
   - Highlight any remaining questions or follow-up needs
