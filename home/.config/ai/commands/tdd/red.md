# Write Failing Unit Test (TDD Red Phase)

## Overview

Write a failing unit test following the TDD Red-Green-Refactor cycle. This is the first phase where you write a test that fails because the functionality doesn't exist yet.

## Steps

1. **Understand the requirement**
   - Clarify what behavior or feature needs to be implemented
   - Identify the expected inputs and outputs
   - Determine edge cases and error conditions

2. **Identify the test location**
   - Find or create the appropriate test file for the unit being tested
   - Follow the project's test file naming conventions (e.g., `*.test.ts`, `*.spec.js`)
   - Place tests in the correct directory structure

3. **Write a descriptive test case**
   - Use clear, descriptive test names that explain the expected behavior
   - Follow the Arrange-Act-Assert (AAA) pattern:
     - **Arrange**: Set up test data and dependencies
     - **Act**: Call the function or method being tested
     - **Assert**: Verify the expected outcome

4. **Define clear assertions**
   - Write assertions that specify the exact expected behavior
   - Include assertions for return values, side effects, and state changes
   - Consider edge cases and error conditions

5. **Run the test to verify it fails**
   - Execute the test suite to confirm the test fails as expected
   - Verify the failure is for the right reason (not due to syntax errors)
   - Document the failure message

## Guidelines

- **Start with the simplest case**: Begin with the most straightforward scenario before adding complexity
- **Test one thing at a time**: Each test should verify a single behavior or requirement
- **Make failure meaningful**: The test should fail in a way that clearly shows what's missing
- **Don't implement yet**: Resist the urge to write production code - that's the Green phase
- **Use descriptive names**: Test names should read like requirements (e.g., `should return empty array when no items match filter`)
- **Follow project conventions**: Match the testing style and patterns used in the codebase

## Next Steps

After confirming the test fails for the right reason, move to the **Green phase** to implement the minimal code needed to make the test pass.
