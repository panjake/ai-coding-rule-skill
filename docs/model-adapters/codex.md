# Codex Adapter

## Common Drift

- If the same sentence contains both profile confirmation and a task, may optimize for the task and skip the identity echo.
- Usually executes tools well, but may treat memory updates as optional cleanup.
- May focus on the implementation path and forget the final handoff path.
- If the workflow is spread across many files, may complete the task before updating memory.
- May optimize for finishing the task quickly and skip an explicit design-confirmation pause.
- May widen a narrow request when it sees a technically cleaner refactor path.

## Strong Prompt

```text
Current developer profile: jake. Only read and write .agents/developers/jake/.

If the same message both confirms identity and assigns a task, still do this first:
1. echo the active profile
2. echo the write boundary
3. only then continue into recovery or task execution

After recovering context, output the recovery summary first.
For non-trivial work:
1. Design the approach
2. Ask for confirmation if the approach changes scope, changes production code, or has non-obvious tradeoffs
3. Code only after confirmation
Before coding, declare the expected write scope.
If the real change grows beyond that scope, stop and confirm again.
If the request is test-only, do not change production code by default.
Treat memory updates as part of the task, not optional cleanup.
At the end of the session, prefer:
- scripts/update-progress.sh
- scripts/append-session.sh
or a single call to scripts/close-session.sh

Before the final response, list the actual written files.
```

## Recovery Check

```text
Do not implement yet.
First output the current profile, write boundary, files read, project-map summary, current progress, risks, and next step.
Then state whether confirmation is required before coding.
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
This session ends here.
Call close-session.sh before the final summary.
If progress or session files were not really written, say so explicitly.
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
The request is test-only.
Do not change production code by default.
If production changes appear necessary, answer only:
1. Why the test cannot be written in the current shape
2. The smallest non-refactor option
3. The refactor option
4. Files that would change in each option
Wait for explicit approval before changing production code.
```

## Scope-Violation Recovery Check

```text
You already crossed the approved scope.
Do not lead with a long technical defense.
Answer only:
1. Original request
2. Actual widened scope
3. Why that widening was out of bounds
4. Smallest compliant option from here
5. Broader option that would require approval
Then stop and wait for the user's decision.
```
