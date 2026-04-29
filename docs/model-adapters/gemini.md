# Gemini Adapter

## Common Drift

- If the same sentence contains both profile confirmation and a task, may move straight into the task and skip the identity echo.
- May move quickly from analysis to implementation if the prompt does not force a pause.
- May widen scope when it sees a more general cleanup or refactor opportunity.
- May summarize a correct workflow without fully executing the file-write steps.
- May under-enforce session-close persistence unless the script call is explicit.

## Strong Prompt

```text
Use the jake profile.
If the same message both confirms identity and assigns a task, still do this first:
1. echo the active profile
2. echo the write boundary
3. only then continue into recovery or task execution

Recover context first and output the recovery summary before any implementation.

For non-trivial work, follow this order:
1. Design the approach
2. Ask for confirmation if the approach changes scope, changes production code, or has non-obvious tradeoffs
3. Code only after confirmation
Before coding, declare the expected write scope.
If the real change grows beyond that scope, stop and confirm again.

If the request is test-only, do not change production code by default.
If production changes appear necessary, stop and present options instead of choosing one silently.

Before ending the session, call scripts/close-session.sh.
Do not stop at a narrative summary.
The final response must list the actual written file paths.
If writing failed, say so explicitly.
```

## Recovery Check

```text
Do not implement yet. Answer only:
1. Current developer profile
2. Write boundary
3. Files read
4. Current progress, risks, and next step
5. Whether confirmation is required before coding
```

## Identity-First Check

```text
The same message confirms the profile and assigns a task.
Do not start the task yet.
First answer only:
1. current developer profile
2. write boundary
3. whether you have already completed the mandatory identity echo
Only after that may you continue into recovery or task execution.
```

## Session-Close Check

```text
End this session now.
Call close-session.sh before the final summary.
Create a new sessions record, not only a progress update.
The final response must list the actual written files.
If writing failed, say so explicitly.
```

## Design-Then-Confirm Check

```text
This is non-trivial work.
Do not code yet. First answer only:
1. Proposed approach
2. Files you expect to change
3. Whether the approach changes production code
4. Whether user confirmation is required before coding
If confirmation is required, stop after the plan and wait.
```

## Write-Scope Check

```text
Before coding, answer only:
1. Expected files or modules to change
2. Whether production code is included
3. What kind of scope growth would require a new confirmation
Do not code before this scope is explicit.
```

## Test-Only Boundary Check

```text
This is a test-only request.
Do not change production code by default.
If you think production changes are required, answer only:
1. Why the test cannot be written in the current shape
2. The smallest non-refactor option
3. The refactor option
4. Files that would change in each option
Wait for explicit approval before changing production code.
```

## Scope-Violation Recovery Check

```text
You already crossed the approved scope.
Do not justify it with a long explanation first.
Answer only:
1. Original request
2. Actual widened scope
3. Why that widening was out of bounds
4. Smallest compliant option from here
5. Broader option that would require approval
Then stop and wait for the user's decision.
```
