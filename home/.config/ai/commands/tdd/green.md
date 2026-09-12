# Implement Code to Pass Test (TDD Green Phase)

## Overview

Write the minimal production code needed to make the failing test pass. This is the second phase of the TDD Red-Green-Refactor cycle where you implement just enough functionality to turn the test green.

## Steps

1. **Review the failing test**
   - Understand what behavior the test is expecting
   - Identify the exact assertions that need to pass
   - Note the expected inputs, outputs, and side effects

2. **Write minimal implementation**
   - Implement just enough code to make the test pass
   - Don't add features that aren't tested yet
   - Avoid premature optimization or over-engineering
   - Focus on making it work, not making it perfect

3. **Run the test**
   - Execute the test suite to verify the new test passes
   - Check that the implementation satisfies all assertions

## Guidelines

- **KISS (Keep It Simple, Stupid)**: The simplest solution that makes the test pass is often the best starting point
- **YAGNI (You Aren't Gonna Need It)**: Don't add functionality that isn't tested
- **No premature optimization**: Focus on correctness first, performance later
- **Fake it till you make it**: It's okay to start with hard-coded values or simple implementations
- **One test at a time**: Make the current test pass before adding more tests
- **Trust the process**: Even if the solution seems too simple, if the test passes, move on to the next cycle

## Common Approaches

- **Fake it**: Return a hard-coded value that makes the test pass
- **Obvious implementation**: If the solution is clear, implement it directly
- **Triangulation**: Add multiple similar tests to drive toward a general solution

## Next Steps

After all tests pass, move to the **Refactor phase** to improve the code quality while keeping tests green.
