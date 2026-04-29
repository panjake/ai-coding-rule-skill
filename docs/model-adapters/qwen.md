# Qwen Adapter

## Common Drift

- If the same sentence contains both profile confirmation and a task, may jump into the task and skip the identity echo.
- Long rule files decay in the second half.
- May produce polite summaries without stable file writes.
- May follow the most recent user sentence and under-enforce workflow rules.
- May acknowledge the rule but skip the script call.
- May jump from a plausible idea straight into implementation without waiting for confirmation.
- May treat a narrow request like "write tests" as permission to widen scope.

## Strong Prompt

Keep the instruction short and command-like:

```text
Use the jake profile.

If the same message both confirms identity and assigns a task, still do this first:
1. echo the active profile
2. echo the write boundary
3. only then continue into recovery or task execution

Read first:
- AGENTS.md
- .agents/common/rules.md
- .agents/common/context.md
- .agents/developers/jake/

Then output the recovery summary first.
For non-trivial work:
1. Design first
2. Ask for confirmation if the approach changes scope or production code
3. Code only after confirmation
Before coding, declare the expected write scope.
If the real change grows beyond that scope, stop and confirm again.
If the request is test-only, do not change production code by default.

Before ending the session, you must call scripts/close-session.sh.
Do not stop at a summary. Really write progress and session files.
If writing fails, say so directly.
```

## Recovery Check

```text
Answer only these 4 items:
1. Current profile
2. Write boundary
3. Files read
4. Current progress and next step
5. For non-trivial work, what must happen before coding?
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
Do not only update progress.
You must call close-session.sh and create a new sessions record.
The final response must list the actual written files.
```

## Design-Then-Confirm Check

```text
Do not code yet.
Answer only:
1. Proposed approach
2. Files you expect to change
3. Whether production code would change
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
Do not explain at length first.
Answer only:
1. Original request
2. Actual widened scope
3. Why that widening was out of bounds
4. Smallest compliant option from here
5. Broader option that would require approval
Then stop and wait.
```
