# Refactor Code While Keeping Tests Green (TDD Refactor Phase)

## Overview

Improve the code quality, design, and structure while ensuring tests continue to pass. This is the third phase of the TDD Red-Green-Refactor cycle where you clean up the implementation without changing behavior.

## Steps

1. **Check current git state**
   - Run `git status` to see any uncommitted changes
   - Run `git log --oneline -n 5` to review recent commits
   - Run `git diff` to see current unstaged changes
   - Understand the context of recent work before refactoring

2. **Identify refactoring opportunities**
   - Look for code duplication (DRY - Don't Repeat Yourself)
   - Check for complex or unclear logic that could be simplified
   - Review naming for clarity and consistency
   - Identify potential design pattern applications
   - Look for magic numbers or hard-coded values

3. **Make one small change at a time**
   - Refactor incrementally, not all at once
   - Choose one improvement to make
   - Apply the refactoring carefully

4. **Run tests after each change**
   - Execute the test suite immediately after each refactoring
   - Ensure the tests still pass (stay green)
   - If tests fail, revert and try a different approach

5. **Improve code quality**
   - Extract methods or functions for better clarity
   - Rename variables, functions, or classes for better understanding
   - Remove duplication by extracting common code
   - Simplify complex conditionals or loops
   - Apply appropriate design patterns
   - Add constants for magic values

6. **Verify final state**
   - Run the test suite one final time
   - Ensure code is cleaner and more maintainable
   - Confirm no functionality was changed

## Guidelines

- **Keep tests green**: If tests fail during refactoring, you've changed behavior
- **Small steps**: Make incremental changes and test frequently
- **Preserve behavior**: Refactoring should not add, remove, or modify functionality
- **Improve readability**: Code should be easier to understand after refactoring
- **Trust your tests**: Your test suite is your safety net - use it
- **Know when to stop**: Don't over-engineer - refactor until the code is clean, then stop

## Common Refactoring Patterns

- **Extract Method**: Pull complex logic into separate functions
- **Rename**: Give variables, functions, and classes more descriptive names
- **Remove Duplication**: DRY up repeated code
- **Simplify Conditionals**: Break down complex if/else chains
- **Extract Constants**: Replace magic numbers with named constants

## Example

```javascript
// Before Refactoring (works but not clean)
function processOrder(o) {
  const t = o.price + o.price * 0.2;
  if (t > 100) {
    return t * 0.9;
  }
  return t;
}

// After Refactoring (cleaner and more maintainable)
const TAX_RATE = 0.2;
const DISCOUNT_THRESHOLD = 100;
const DISCOUNT_RATE = 0.1;

function calculateTotalWithTax(order) {
  return order.price + order.price * TAX_RATE;
}

function applyDiscountIfEligible(total) {
  if (total > DISCOUNT_THRESHOLD) {
    return total * (1 - DISCOUNT_RATE);
  }
  return total;
}

function processOrder(order) {
  const totalWithTax = calculateTotalWithTax(order);
  return applyDiscountIfEligible(totalWithTax);
}
```

## Next Steps

After refactoring is complete and all tests are green, start the cycle again:

1. Write the next failing test (**Red phase**)
2. Make it pass (**Green phase**)
3. Clean it up (**Refactor phase**)

Repeat until the feature is complete!
