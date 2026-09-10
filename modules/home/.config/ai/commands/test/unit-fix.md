# Fix Failing Unit Tests

## Overview

Identify and fix tests that are failing due to changes in the head branch

## Steps

2. **Analyze head branch changes**
   - Use `git diff main...HEAD` to compare current branch with the base branch
   - Identify what changed in the head branch that might affect the tests

3. **Understand test failures**
   - Review each failing test to understand what it's testing
   - Determine if the test logic is outdated or if it needs to adapt to new changes
   - Check if the test expectations need to be updated

4. **Fix the tests**
   - Update test assertions to match new behavior
   - Update mocks, stubs, or fixtures if needed
   - Update test data or expected outputs
   - Ensure tests still validate the intended behavior

5. **Verify fixes**
   - Run the updated tests to confirm they pass
   - Ensure no other tests added in the head branch were broken by the changes

## Guidelines

- Don't just make tests pass - ensure they still test the right behavior
