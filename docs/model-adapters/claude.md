# Claude Adapter

## Common Drift

- If the same sentence contains both profile confirmation and a task, may politely continue into the task without an explicit identity echo.
- Usually summarizes well, but may blur the line between planned actions and completed actions.
- May describe the correct workflow without actually writing files.
- May stop after a clean narrative summary unless file-write requirements are explicit.
- May produce a polished plan and then continue into coding without an explicit confirmation pause.
- May rationalize a production refactor as the cleanest path for a test-only task.

## Strong Prompt

```text
Use the jake profile.
If the same message both confirms identity and assigns a task, still do this first:
1. echo the active profile
2. echo the write boundary
3. only then continue into recovery or task execution

Recover context according to the rules and output the recovery summary first.
For non-trivial work:
1. Design first
2. Ask for confirmation if the approach changes scope, changes production code, or has non-obvious tradeoffs
3. Code only after confirmation
Before coding, declare the expected write scope.
If the real change grows beyond that scope, stop and confirm again.
If the request is test-only, do not change production code unless it is explicitly approved.

Before ending the session, perform file writes before the summary:
- prefer calling scripts/close-session.sh
- really update progress.md
- really add one new sessions record
- update bugs.md when a new problem was confirmed
- add a decisions record when a stable decision was made

The final response must distinguish:
1. files actually written
2. things that were not completed
```

## Recovery Check

```text
Do not continue implementation yet.
First state:
- current profile
- write boundary
- memory files read
- current progress
- known risks
- next step
- whether confirmation is required before coding
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
Before ending the session, do not stop at a summary.
Run close-session.sh first.
The final response should contain only:
1. actual written file paths
2. failure reasons if writing failed
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
Do not start with a long explanation.
Answer only:
1. Original request
2. Actual widened scope
3. Why that widening was out of bounds
4. Smallest compliant option from here
5. Broader option that would require approval
Then stop and wait for the user's decision.
```
